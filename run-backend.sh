#!/bin/bash

# Backend Run Script (without Docker)
# This script runs the Fake News Detection backend service

set -e

cd "$(dirname "$0")/backend"

echo "🔧 Setting up backend..."

# Check if bun is installed
if ! command -v bun &> /dev/null; then
    echo "❌ Error: bun is not installed"
    echo "   Please install bun from https://bun.sh"
    exit 1
fi

# Check if dependencies are installed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    bun install
fi

# Check if .env file exists, create template if not
if [ ! -f ".env" ]; then
    echo "📝 Creating .env file template..."
    cat > .env << EOF
# OpenAI API Configuration
OPENAI_API_KEY=
AI_URL=
AI_MODEL=gpt-4o-mini
PORT=3000
EOF
    echo "⚠️  Please edit backend/.env and set OPENAI_API_KEY"
fi

# Load environment variables from .env if it exists
if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Check if port is in use and kill existing process
PORT=${PORT:-3000}
PID=""

# Try lsof first (most reliable)
if command -v lsof &> /dev/null; then
    PID=$(lsof -ti:$PORT 2>/dev/null || echo "")
fi

# Fallback to ss if lsof not available
if [ -z "$PID" ] && command -v ss &> /dev/null; then
    PID=$(ss -lptn "sport = :$PORT" 2>/dev/null | grep -oP 'pid=\K\d+' | head -1 || echo "")
fi

# Fallback to fuser if available
if [ -z "$PID" ] && command -v fuser &> /dev/null; then
    PID=$(fuser $PORT/tcp 2>/dev/null | grep -oP '\d+' | head -1 || echo "")
fi

if [ -n "$PID" ]; then
    echo "⚠️  Port $PORT is in use (PID: $PID), killing process..."
    kill -9 $PID 2>/dev/null || true
    sleep 1
fi

echo "🚀 Starting Fake News Detection Backend..."
echo "   Port: $PORT"
echo "   AI Service: \${AI_URL:-OpenAI API}"
echo ""

# Run the backend
bun run main.ts
