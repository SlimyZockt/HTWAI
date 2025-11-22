#!/bin/bash

# Frontend Run Script (without Docker)
# This script runs the Fake News Detection frontend service

set -e

cd "$(dirname "$0")/frontend"

echo "🔧 Setting up frontend..."

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "❌ Error: Go is not installed"
    echo "   Please install Go from https://go.dev"
    exit 1
fi

# Check if templ is installed
if ! command -v templ &> /dev/null; then
    echo "📦 Installing templ..."
    go install github.com/a-h/templ/cmd/templ@latest
fi

# Check if bun is installed (for Tailwind CSS)
if ! command -v bun &> /dev/null; then
    echo "❌ Error: bun is not installed (needed for Tailwind CSS)"
    echo "   Please install bun from https://bun.sh"
    exit 1
fi

# Generate templ files
echo "🔨 Generating templ files..."
templ generate

# Build Tailwind CSS if output.css doesn't exist or style.css is newer
if [ ! -f "include_dir/output.css" ] || [ "style.css" -nt "include_dir/output.css" ]; then
    echo "🎨 Building Tailwind CSS..."
    if [ ! -d "node_modules" ]; then
        bun install
    fi
    bun x tailwindcss -i style.css -o include_dir/output.css -m
fi

# Check if Go dependencies are installed
if [ ! -f "go.sum" ] || ! go mod verify &> /dev/null; then
    echo "📦 Installing Go dependencies..."
    go mod download
fi

# Load environment variables from .env if it exists
if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
fi

echo "🚀 Starting Fake News Detection Frontend..."
echo "   Port: 8080"
echo "   Backend URL: \${BACKEND_URL:-http://localhost:3000}"
echo ""

# Run the frontend
go run main.go
