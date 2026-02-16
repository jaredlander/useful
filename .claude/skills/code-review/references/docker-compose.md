# Docker Compose Code Review Reference

## Priority Focus
- Security configuration
- Production readiness
- Service dependencies and health
- Resource management

## Security

### Never Hardcode Secrets
```yaml
# BAD: Secrets in compose file
services:
  db:
    environment:
      POSTGRES_PASSWORD: supersecret123  # Never!

# GOOD: Use environment variables
services:
  db:
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}

# GOOD: Use secrets (Swarm mode or external)
services:
  db:
    secrets:
      - db_password
secrets:
  db_password:
    external: true

# GOOD: Use .env file (not committed)
# .env
DB_PASSWORD=supersecret123
```

### Principle of Least Privilege
```yaml
# BAD: Privileged mode
services:
  app:
    privileged: true  # Almost never needed!

# BAD: Full host access
services:
  app:
    volumes:
      - /:/host  # Full host filesystem!
    network_mode: host  # Full host network!

# GOOD: Minimal capabilities
services:
  app:
    cap_drop:
      - ALL
    cap_add:
      - NET_BIND_SERVICE  # Only what's needed
    read_only: true
    security_opt:
      - no-new-privileges:true
```

### User Configuration
```yaml
# GOOD: Run as non-root
services:
  app:
    user: "1000:1000"
    # Or in Dockerfile: USER nonroot
```

## Service Dependencies

### Health Checks
```yaml
# BAD: depends_on without health check
services:
  app:
    depends_on:
      - db  # Only waits for container start, not readiness!

# GOOD: With health check conditions
services:
  db:
    image: postgres:15
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 30s

  app:
    depends_on:
      db:
        condition: service_healthy
```

### Startup Order
```yaml
# Multiple dependencies with health checks
services:
  app:
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy
      migrations:
        condition: service_completed_successfully
```

## Resource Management

### Always Set Limits
```yaml
# BAD: No resource limits
services:
  app:
    image: myapp

# GOOD: With limits
services:
  app:
    image: myapp
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 128M
```

### Restart Policies
```yaml
# GOOD: Appropriate restart policy
services:
  app:
    restart: unless-stopped  # Survives reboots

  worker:
    restart: on-failure
    deploy:
      restart_policy:
        condition: on-failure
        max_attempts: 3
        delay: 5s
```

## Networking

### Named Networks
```yaml
# BAD: Default network for everything
services:
  app:
    # Uses default network

# GOOD: Explicit networks
services:
  app:
    networks:
      - frontend
      - backend

  db:
    networks:
      - backend  # Not exposed to frontend

networks:
  frontend:
  backend:
    internal: true  # No external access
```

### Port Exposure
```yaml
# BAD: Binding to all interfaces
ports:
  - "3306:3306"  # Exposed to world!

# GOOD: Bind to localhost only
ports:
  - "127.0.0.1:3306:3306"

# GOOD: Internal-only services don't need ports
services:
  db:
    # No ports section - only accessible via network
```

## Volumes

### Named Volumes for Persistence
```yaml
# BAD: Anonymous volumes (hard to manage)
volumes:
  - /var/lib/postgresql/data

# GOOD: Named volumes
services:
  db:
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
    # Persists across container recreation
```

### Bind Mount Best Practices
```yaml
# Development: bind mounts for hot reload
services:
  app:
    volumes:
      - ./src:/app/src:ro  # Read-only where possible
      - ./config:/app/config:ro

# GOOD: Use long syntax for clarity
volumes:
  - type: bind
    source: ./src
    target: /app/src
    read_only: true
```

## Production Readiness

### Logging Configuration
```yaml
services:
  app:
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"
        tag: "{{.Name}}/{{.ID}}"
```

### Image Tags
```yaml
# BAD: Latest or no tag
services:
  app:
    image: myapp
    image: myapp:latest

# GOOD: Specific version
services:
  app:
    image: myapp:1.2.3
    # Or with digest
    image: myapp@sha256:abc123...
```

### Environment Files
```yaml
# GOOD: Separate env files per environment
services:
  app:
    env_file:
      - .env.common
      - .env.${ENVIRONMENT:-development}
```

## Compose File Organization

### Use Profiles for Optional Services
```yaml
services:
  app:
    image: myapp

  debug-tools:
    image: debug:latest
    profiles:
      - debug  # Only starts with --profile debug

  monitoring:
    image: prometheus
    profiles:
      - monitoring
```

### Extend and Override
```yaml
# docker-compose.yml (base)
services:
  app:
    image: myapp
    environment:
      - LOG_LEVEL=info

# docker-compose.override.yml (dev, auto-loaded)
services:
  app:
    volumes:
      - ./src:/app/src
    environment:
      - LOG_LEVEL=debug

# docker-compose.prod.yml
services:
  app:
    deploy:
      replicas: 3
      resources:
        limits:
          memory: 512M
```

### Include (Compose 2.20+)
```yaml
# docker-compose.yml
include:
  - path: ./services/db/compose.yml
  - path: ./services/cache/compose.yml

services:
  app:
    depends_on:
      - db
      - redis
```

## Common Pitfalls

- Secrets in compose file or .env committed to git
- Missing health checks causing race conditions
- No resource limits (OOM kills)
- Using `latest` tag
- Exposing ports to 0.0.0.0
- Anonymous volumes
- Not using networks for isolation
- Missing restart policies
- `depends_on` without health condition

## Security Checklist

- [ ] No hardcoded secrets
- [ ] No privileged containers
- [ ] Non-root user where possible
- [ ] Read-only filesystem where possible
- [ ] Internal networks for backend services
- [ ] Ports bound to localhost when possible
- [ ] Resource limits set
- [ ] Specific image versions pinned
- [ ] Capabilities dropped
