# syntax=docker/dockerfile:1
FROM alpine:3.21 AS final
WORKDIR /app

# Install dependencies including C++ libraries for Bun
RUN --mount=type=cache,target=/var/cache/apk \
    apk --update add \
    curl \
    bash \
    ca-certificates \
    gcompat \
    libstdc++ \
    unzip

# Install Bun (latest version)
RUN curl -fsSL https://bun.com/install | bash
ENV PATH="/root/.bun/bin:${PATH}"

# Copy package files first for better caching
COPY package.json bun.lock* ./

# Install dependencies
RUN bun install

# Copy source files
COPY . .

EXPOSE 3000

# Run the server
CMD ["bun", "run", "main.ts"]
