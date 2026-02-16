# Dockerfile Code Review Reference

## Priority Focus
- Security (minimal attack surface, non-root)
- Image size optimization
- Build reproducibility
- Layer caching efficiency

## Security

### Run as Non-Root
```dockerfile
# BAD: Runs as root (default)
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y nginx
CMD ["nginx", "-g", "daemon off;"]

# GOOD: Create and use non-root user
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y nginx \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -r -s /bin/false nginx-user
USER nginx-user
CMD ["nginx", "-g", "daemon off;"]
```

### Minimal Base Images
```dockerfile
# Flag: Large base images when smaller alternatives exist
FROM ubuntu:22.04      # ~77MB
FROM python:3.11       # ~1GB

# GOOD: Minimal alternatives
FROM ubuntu:22.04-minimal  # Smaller
FROM python:3.11-slim      # ~150MB
FROM python:3.11-alpine    # ~50MB (but glibc issues)
FROM gcr.io/distroless/python3  # Very minimal
```

### No Secrets in Images
```dockerfile
# BAD: Secrets in build args or ENV
ARG DB_PASSWORD
ENV API_KEY=abc123

# BAD: Copying secret files
COPY credentials.json /app/

# GOOD: Use runtime secrets
# Mount secrets at runtime, not build time
# Use Docker secrets, Kubernetes secrets, or env vars
```

### Pin Versions
```dockerfile
# BAD: Unpinned versions
FROM python:latest
RUN pip install flask

# GOOD: Pinned versions
FROM python:3.11.7-slim-bookworm
RUN pip install flask==3.0.0

# GOOD: Use SHA256 digest for base image
FROM python@sha256:abc123...
```

### Verify Downloads
```dockerfile
# BAD: Unverified download
RUN curl -o /app.tar.gz https://example.com/app.tar.gz \
    && tar -xzf /app.tar.gz

# GOOD: Verify checksum
RUN curl -o /app.tar.gz https://example.com/app.tar.gz \
    && echo "expected_sha256  /app.tar.gz" | sha256sum -c - \
    && tar -xzf /app.tar.gz
```

## Image Size Optimization

### Multi-Stage Builds
```dockerfile
# GOOD: Multi-stage for compiled languages
FROM golang:1.21 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o /app/server

FROM gcr.io/distroless/static-debian12
COPY --from=builder /app/server /server
ENTRYPOINT ["/server"]
```

### Minimize Layers
```dockerfile
# BAD: Many layers
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y git
RUN rm -rf /var/lib/apt/lists/*

# GOOD: Single layer
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        git \
    && rm -rf /var/lib/apt/lists/*
```

### Clean Up in Same Layer
```dockerfile
# BAD: Cleanup in separate layer (space not reclaimed)
RUN apt-get update && apt-get install -y build-essential
RUN make install
RUN apt-get remove -y build-essential  # Too late!

# GOOD: Install, use, remove in one layer
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential \
    && make install \
    && apt-get remove -y build-essential \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*
```

### Use .dockerignore
```dockerfile
# .dockerignore
.git
.gitignore
README.md
docker-compose*.yml
.env*
__pycache__
*.pyc
node_modules
.venv
```

## Layer Caching

### Order for Optimal Caching
```dockerfile
# GOOD: Dependency files first, then code
# Dependencies change less frequently than code

# 1. Base image
FROM python:3.11-slim

# 2. Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# 3. Copy dependency manifests
COPY requirements.txt .

# 4. Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy application code (most frequent changes)
COPY . .

# 6. Build step if needed
RUN python setup.py build

CMD ["python", "app.py"]
```

### Use Build Cache Mounts
```dockerfile
# Cache pip downloads
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r requirements.txt

# Cache apt downloads
RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && apt-get install -y nginx
```

## Best Practices

### Use COPY Over ADD
```dockerfile
# BAD: ADD has magic behavior
ADD app.tar.gz /app/          # Auto-extracts
ADD https://example.com/file  # Downloads

# GOOD: COPY is explicit
COPY app/ /app/

# Only use ADD for tar extraction when intended
```

### Explicit WORKDIR
```dockerfile
# BAD: cd commands
RUN cd /app && npm install

# GOOD: Use WORKDIR
WORKDIR /app
RUN npm install
```

### ENTRYPOINT vs CMD
```dockerfile
# Use ENTRYPOINT for the main executable
# Use CMD for default arguments

# GOOD: Flexible pattern
ENTRYPOINT ["python", "app.py"]
CMD ["--port", "8080"]

# Allows: docker run myimage --port 9090

# GOOD: Shell form for exec replacement
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
```

### Health Checks
```dockerfile
# GOOD: Include health check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1
```

### Labels for Metadata
```dockerfile
LABEL org.opencontainers.image.source="https://github.com/org/repo"
LABEL org.opencontainers.image.version="1.2.3"
LABEL org.opencontainers.image.description="Application description"
LABEL maintainer="team@example.com"
```

## Common Pitfalls

- Using `latest` tag (non-reproducible)
- Running as root
- Secrets in image layers
- Installing unnecessary packages
- Not cleaning up package manager cache
- ADD instead of COPY
- Poor layer ordering (invalidates cache)
- Missing .dockerignore
- COPY . . before dependency install

## Security Checklist

- [ ] Non-root USER specified
- [ ] Base image pinned to digest or specific version
- [ ] No secrets or credentials in image
- [ ] Minimal base image used
- [ ] Unnecessary tools removed
- [ ] COPY used instead of ADD (unless extracting)
- [ ] Downloads verified with checksums
- [ ] Read-only filesystem where possible
