import OpenAI from "openai";

// Get AI URL from environment
// If API key is set but no URL, use OpenAI's official API
// Otherwise default to local server (for development)
const AI_API_KEY = process.env.OPENAI_API_KEY || "";
const AI_URL_ENV = process.env.AI_URL || "";
const AI_MODEL = process.env.AI_MODEL || "gpt-4o-mini";

// Determine AI URL: use env var if set, otherwise use OpenAI if API key exists, else local
const AI_URL = AI_URL_ENV || (
    AI_API_KEY 
        ? undefined // undefined means use OpenAI's default (https://api.openai.com/v1)
        : "http://127.0.0.1:1234/v1" // Local server default (only if no API key and no URL)
);

// Create OpenAI client
const ai_client_config: {
    apiKey: string;
    baseURL?: string;
} = {
    apiKey: AI_API_KEY || "not-needed-for-local",
};

if (AI_URL) {
    ai_client_config.baseURL = AI_URL;
}

const ai_client = new OpenAI(ai_client_config);

// Load system prompt for fake news detection
const AI_SYSTEM_PROMPT = await Bun.file("./systmpormt.md").text();

// CORS headers helper
function getCorsHeaders(): Record<string, string> {
    return {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type",
    };
}

// Handler for OPTIONS (CORS preflight)
function handleOptions(): Response {
    return new Response(null, {
        status: 204,
        headers: getCorsHeaders(),
    });
}

// Handler for status endpoint
async function handleStatus(req: Request): Promise<Response> {
    if (req.method === "OPTIONS") {
        return handleOptions();
    }
    
    if (req.method !== "GET") {
        return new Response(JSON.stringify({ error: "Method not allowed" }), {
            status: 405,
            headers: { 
                "Content-Type": "application/json",
                ...getCorsHeaders(),
            },
        });
    }

    return new Response(
        JSON.stringify({
            status: "ok",
            service: "Fake News Detection API",
            timestamp: new Date().toISOString(),
        }),
        {
            status: 200,
            headers: { 
                "Content-Type": "application/json",
                ...getCorsHeaders(),
            },
        }
    );
}

// Handler for streaming analyze endpoint
async function handleAnalyze(req: Request): Promise<Response> {
    if (req.method === "OPTIONS") {
        return handleOptions();
    }
    
    if (req.method !== "POST") {
        return new Response(JSON.stringify({ error: "Method not allowed" }), {
            status: 405,
            headers: { 
                "Content-Type": "application/json",
                ...getCorsHeaders(),
            },
        });
    }

    try {
        // Parse request body
        const body = await req.json() as { text?: string };
        const text = body.text;

        if (!text || typeof text !== "string" || text.trim().length === 0) {
            return new Response(
                JSON.stringify({ error: "Text is required and must be a non-empty string" }),
                {
                    status: 400,
                    headers: { 
                        "Content-Type": "application/json",
                        ...getCorsHeaders(),
                    },
                }
            );
        }

        // Create streaming response
        const stream = new ReadableStream({
            async start(controller) {
                try {
                    // Create OpenAI chat completion with streaming
                    const stream = await ai_client.chat.completions.create({
                        model: AI_MODEL,
                        messages: [
                            { role: "system", content: AI_SYSTEM_PROMPT },
                            { role: "user", content: text },
                        ],
                        stream: true,
                    });

                    // Stream chunks to client
                    for await (const chunk of stream) {
                        const content = chunk.choices[0]?.delta?.content || "";
                        if (content) {
                            controller.enqueue(new TextEncoder().encode(content));
                        }
                    }

                    controller.close();
                } catch (error: any) {
                    console.error("Error in streaming:", error);
                    const errorMessage = error?.message || "An error occurred during analysis";
                    controller.enqueue(
                        new TextEncoder().encode(`\n\n[Fehler: ${errorMessage}]`)
                    );
                    controller.close();
                }
            },
        });

        return new Response(stream, {
            status: 200,
            headers: {
                "Content-Type": "text/plain; charset=utf-8",
                "Cache-Control": "no-cache",
                "Connection": "keep-alive",
                ...getCorsHeaders(),
            },
        });
    } catch (error: any) {
        console.error("Error handling analyze request:", error);
        return new Response(
            JSON.stringify({
                error: error?.message || "Failed to process analysis request",
            }),
            {
                status: 500,
                headers: { 
                    "Content-Type": "application/json",
                    ...getCorsHeaders(),
                },
            }
        );
    }
}

// Handler for complete (non-streaming) analyze endpoint
async function handleAnalyzeComplete(req: Request): Promise<Response> {
    if (req.method === "OPTIONS") {
        return handleOptions();
    }
    
    if (req.method !== "POST") {
        return new Response(JSON.stringify({ error: "Method not allowed" }), {
            status: 405,
            headers: { 
                "Content-Type": "application/json",
                ...getCorsHeaders(),
            },
        });
    }

    try {
        // Parse request body
        const body = await req.json() as { text?: string };
        const text = body.text;

        if (!text || typeof text !== "string" || text.trim().length === 0) {
            return new Response(
                JSON.stringify({ error: "Text is required and must be a non-empty string" }),
                {
                    status: 400,
                    headers: { 
                        "Content-Type": "application/json",
                        ...getCorsHeaders(),
                    },
                }
            );
        }

        // Create non-streaming completion
        const completion = await ai_client.chat.completions.create({
            model: AI_MODEL,
            messages: [
                { role: "system", content: AI_SYSTEM_PROMPT },
                { role: "user", content: text },
            ],
            stream: false,
        });

        const result = completion.choices[0]?.message?.content || "No response generated";

        return new Response(
            JSON.stringify({
                result: result,
                model: completion.model,
                usage: completion.usage,
            }),
            {
                status: 200,
                headers: { 
                    "Content-Type": "application/json",
                    ...getCorsHeaders(),
                },
            }
        );
    } catch (error: any) {
        console.error("Error handling analyze complete request:", error);
        return new Response(
            JSON.stringify({
                error: error?.message || "Failed to process analysis request",
            }),
            {
                status: 500,
                headers: { 
                    "Content-Type": "application/json",
                    ...getCorsHeaders(),
                },
            }
        );
    }
}

// Start server
const server = Bun.serve({
    port: process.env.PORT || 3000,
    routes: {
        "/api/status": handleStatus,
        "/api/analyze": handleAnalyze,
        "/api/analyze/complete": handleAnalyzeComplete,
    },
});

console.log(`🚀 Fake News Detection API running at ${server.url}`);
console.log(`   Health: ${server.url}/api/status`);
console.log(`   Analyze (streaming): ${server.url}/api/analyze`);
console.log(`   Analyze (complete): ${server.url}/api/analyze/complete`);
console.log(`   AI Service: ${AI_URL || "OpenAI API (https://api.openai.com/v1)"}`);
console.log(`   AI Model: ${AI_MODEL}`);
if (!AI_URL) {
    console.log(`   API Key: ${AI_API_KEY ? "***configured***" : "⚠️  NOT SET - Please set OPENAI_API_KEY environment variable"}`);
} else {
    console.log(`   API Key: ${AI_API_KEY ? "***configured***" : "Not required (local AI server)"}`);
}
