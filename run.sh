#!/bin/bash

# Main Run Script (without Docker)
# This script runs both backend and frontend services

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Fake News Detection - Local Development      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""

# Check prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"

MISSING_DEPS=()

if ! command -v bun &> /dev/null; then
    MISSING_DEPS+=("bun (https://bun.sh)")
fi

if ! command -v go &> /dev/null; then
    MISSING_DEPS+=("go (https://go.dev)")
fi

if ! command -v templ &> /dev/null; then
    echo -e "${YELLOW}⚠️  templ not found, will install automatically...${NC}"
fi

if [ ${#MISSING_DEPS[@]} -ne 0 ]; then
    echo -e "${RED}❌ Missing required dependencies:${NC}"
    for dep in "${MISSING_DEPS[@]}"; do
        echo -e "   ${RED}- $dep${NC}"
    done
    exit 1
fi

echo -e "${GREEN}✓ All prerequisites found${NC}"
echo ""

# Check if .env files exist
if [ ! -f "backend/.env" ]; then
    echo -e "${YELLOW}📝 Creating backend/.env template...${NC}"
    cat > backend/.env << 'EOF'
# OpenAI API Configuration
OPENAI_API_KEY=
AI_URL=
AI_MODEL=gpt-4o-mini
PORT=3000
EOF
    echo -e "${YELLOW}⚠️  Please edit backend/.env and set OPENAI_API_KEY${NC}"
    echo ""
fi

# Function to kill process on a port
kill_port() {
    local port=$1
    local pid=""
    
    # Try lsof first (most reliable)
    if command -v lsof &> /dev/null; then
        pid=$(lsof -ti:$port 2>/dev/null || echo "")
    fi
    
    # Fallback to ss if lsof not available
    if [ -z "$pid" ] && command -v ss &> /dev/null; then
        pid=$(ss -lptn "sport = :$port" 2>/dev/null | grep -oP 'pid=\K\d+' | head -1 || echo "")
    fi
    
    # Fallback to fuser if available
    if [ -z "$pid" ] && command -v fuser &> /dev/null; then
        pid=$(fuser $port/tcp 2>/dev/null | grep -oP '\d+' | head -1 || echo "")
    fi
    
    if [ -n "$pid" ]; then
        echo -e "${YELLOW}⚠️  Port $port is in use (PID: $pid), killing process...${NC}"
        kill -9 $pid 2>/dev/null || true
        sleep 1
    fi
}

# Function to cleanup on exit
cleanup() {
    echo ""
    echo -e "${YELLOW}Shutting down services...${NC}"
    # Kill the actual processes first
    kill $BACKEND_PID 2>/dev/null || true
    kill $FRONTEND_PID 2>/dev/null || true
    # Kill any tee processes
    pkill -P $$ tee 2>/dev/null || true
    wait $BACKEND_PID 2>/dev/null || true
    wait $FRONTEND_PID 2>/dev/null || true
    echo -e "${GREEN}✓ Services stopped${NC}"
    exit 0
}

# Trap SIGINT and SIGTERM
trap cleanup SIGINT SIGTERM

# Check and free ports
echo -e "${YELLOW}Checking ports...${NC}"
kill_port 3000
kill_port 8080
echo ""

# Start backend
echo -e "${BLUE}🚀 Starting backend...${NC}"
cd "$SCRIPT_DIR/backend"

# Load backend .env
if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Install backend dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing backend dependencies..."
    bun install
fi

# Create log files
> /tmp/htwai-backend.log
> /tmp/htwai-frontend.log

# Start backend with logs visible in terminal and saved to file
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Backend Logs${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
(bun run main.ts 2>&1 | tee /tmp/htwai-backend.log) &
BACKEND_PID=$!
cd "$SCRIPT_DIR"

# Wait a bit for backend to start
sleep 2

# Check if backend started successfully (check if process group exists)
if ! ps -p $BACKEND_PID > /dev/null 2>&1; then
    echo -e "${RED}❌ Backend failed to start. Check /tmp/htwai-backend.log${NC}"
    cat /tmp/htwai-backend.log
    exit 1
fi

echo -e "${GREEN}✓ Backend started (PID: $BACKEND_PID)${NC}"
echo -e "${GREEN}✓ Backend logs are visible above and saved to /tmp/htwai-backend.log${NC}"
echo ""

# Start frontend
echo -e "${BLUE}🚀 Starting frontend...${NC}"
cd "$SCRIPT_DIR/frontend"

# Generate templ files
echo "🔨 Generating templ files..."
templ generate > /dev/null 2>&1 || true

# Build Tailwind CSS if needed
if [ ! -f "include_dir/output.css" ] || [ "style.css" -nt "include_dir/output.css" ]; then
    echo "🎨 Building Tailwind CSS..."
    if [ ! -d "node_modules" ]; then
        bun install
    fi
    bun x tailwindcss -i style.css -o include_dir/output.css -m > /dev/null 2>&1
fi

# Install Go dependencies if needed
if [ ! -f "go.sum" ] || ! go mod verify &> /dev/null 2>&1; then
    echo "📦 Installing Go dependencies..."
    go mod download
fi

# Load frontend .env
if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Start frontend with logs visible in terminal and saved to file
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Frontend Logs${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
(go run main.go 2>&1 | tee /tmp/htwai-frontend.log) &
FRONTEND_PID=$!
cd "$SCRIPT_DIR"

# Wait a bit for frontend to start
sleep 2

# Check if frontend started successfully (check if process group exists)
if ! ps -p $FRONTEND_PID > /dev/null 2>&1; then
    echo -e "${RED}❌ Frontend failed to start. Check /tmp/htwai-frontend.log${NC}"
    cat /tmp/htwai-frontend.log
    cleanup
    exit 1
fi

echo -e "${GREEN}✓ Frontend started (PID: $FRONTEND_PID)${NC}"
echo -e "${GREEN}✓ Frontend logs are visible above and saved to /tmp/htwai-frontend.log${NC}"
echo ""

# Display status
echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Services are running!                        ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📍 Backend:${NC}  http://localhost:3000"
echo -e "${BLUE}📍 Frontend:${NC} http://localhost:8080"
echo ""
echo -e "${YELLOW}Press Ctrl+C to stop all services${NC}"
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Live Logs (logs are also saved to /tmp/)${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo ""

# Wait for processes and show their output in real-time
wait $BACKEND_PID $FRONTEND_PID 2>/dev/null || true
