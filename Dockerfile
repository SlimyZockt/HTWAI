# Bun-basierte API-Containerisierung
FROM debian:bookworm-slim

# Install dependencies and Bun
RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates curl \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /workspace

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash
ENV BUN_INSTALL=/root/.bun
ENV PATH=${BUN_INSTALL}/bin:${PATH}

# Copy API code
WORKDIR /workspace
COPY ai_api /workspace/ai_api

# Install dependencies for the API (if any)
WORKDIR /workspace/ai_api
RUN bun install

# Expose ports for API instances
EXPOSE 3000 3001

# Run the API (Port is controlled via PORT env var with default 3000)
CMD ["bunx", "/workspace/ai_api/main.ts"]
