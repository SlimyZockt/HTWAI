# Development Guide - Running Without Docker

This guide explains how to run the Fake News Detection project locally without Docker.

## Prerequisites

Make sure you have the following installed:

- **Bun**: JavaScript runtime (https://bun.sh)
- **Go**: Programming language (https://go.dev)
- **templ**: Go template generator (will be auto-installed if missing)

Install templ manually if needed:
```bash
go install github.com/a-h/templ/cmd/templ@latest
```

## Quick Start

### Option 1: Run Everything at Once

Use the main script to start both backend and frontend:

```bash
./run.sh
```

This will:
- Check prerequisites
- Create `.env` templates if needed
- Install dependencies automatically
- Start backend and frontend in parallel
- Show logs and status

Press `Ctrl+C` to stop all services.

### Option 2: Run Services Separately

#### Start Backend Only

```bash
./run-backend.sh
```

Backend will run on `http://localhost:3000`

#### Start Frontend Only

```bash
./run-frontend.sh
```

Frontend will run on `http://localhost:8080`

## Configuration

### Backend Configuration

1. Copy the example environment file:
   ```bash
   cp backend/.env.example backend/.env
   ```

2. Edit `backend/.env` and set your OpenAI API key:
   ```bash
   OPENAI_API_KEY=your-key-here
   ```

**Options:**
- **OpenAI API** (default): Set `OPENAI_API_KEY` and leave `AI_URL` empty
- **Local AI Server**: Set `AI_URL=http://127.0.0.1:1234/v1`

### Frontend Configuration

Frontend automatically detects the backend at `http://localhost:3000`.

To use a different backend URL, create `frontend/.env`:
```bash
cp frontend/.env.example frontend/.env
# Edit frontend/.env if needed
```

## Manual Setup

If you prefer to run services manually:

### Backend

```bash
cd backend

# Install dependencies
bun install

# Set environment variables
export OPENAI_API_KEY=your-key-here
# Or load from .env file

# Run the server
bun run main.ts
```

### Frontend

```bash
cd frontend

# Generate templ files
templ generate

# Install dependencies
bun install

# Build Tailwind CSS
bun x tailwindcss -i style.css -o include_dir/output.css -m

# Install Go dependencies
go mod download

# Run the server
go run main.go
```

## Accessing the Application

Once both services are running:

- **Frontend**: http://localhost:8080
- **Backend API**: http://localhost:3000
- **Backend Health Check**: http://localhost:3000/api/status

## Troubleshooting

### Backend Issues

1. **Connection Error**: Make sure `OPENAI_API_KEY` is set correctly
2. **Port Already in Use**: Change `PORT` in `backend/.env` or kill the process using port 3000
3. **Dependencies Missing**: Run `bun install` in the backend directory

### Frontend Issues

1. **Template Errors**: Run `templ generate` in the frontend directory
2. **CSS Not Loading**: Rebuild Tailwind CSS:
   ```bash
   cd frontend
   bun x tailwindcss -i style.css -o include_dir/output.css -m
   ```
3. **Port Already in Use**: Kill the process using port 8080 or change the port in `main.go`

### Viewing Logs

When using `run.sh`, logs are saved to:
- Backend: `/tmp/htwai-backend.log`
- Frontend: `/tmp/htwai-frontend.log`

View logs in real-time:
```bash
tail -f /tmp/htwai-backend.log
tail -f /tmp/htwai-frontend.log
```

## Development Tips

- Use `bun --watch main.ts` for auto-reload on backend changes
- Rebuild Tailwind CSS when changing `style.css` or HTML classes
- Run `templ generate` when modifying `.templ` files
- Check `.env` files for configuration options
