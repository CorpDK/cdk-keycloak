# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a custom Keycloak deployment for CorpDK, containerized and configured for deployment on Railway. It extends the official Keycloak 26.3.4 image with Phase Two enterprise extensions and additional identity providers.

## Architecture

### Multi-Stage Docker Build
The build process uses a multi-stage Dockerfile (`keycloak/Dockerfile`):
1. **phasetwo stage**: Pulls Phase Two Keycloak image to extract provider JARs
2. **builder stage**: Extends official Keycloak, copies Phase Two providers, downloads additional providers (Apple IdP), and runs `kc.sh build`
3. **final stage**: Clean runtime image with all built artifacts

### Provider Extensions
Phase Two enterprise providers (copied from phasetwo-keycloak):
- dnsjava
- Admin Portal (requires client creation)
- IdP Wizards
- Events
- Magic Link
- Organizations
- Themes
- Wildfly Client Config
- Admin UI (from custom branch 26.3.0_orgs_adminui_1)

Additional third-party providers:
- Apple Identity Provider (v1.16.0)

Commented/disabled:
- Discord provider
- SCIM extension
- User Migration

### Database Configuration
- Uses PostgreSQL with connection pooling (min: 1, max: 10)
- `startup.sh` parses `DATABASE_URL` env var (postgres:// format) into separate KC_DB_* variables
- SSL mode required via `KC_DB_URL_PROPERTIES="?sslmode=require"`

### Deployment Configuration
Railway-specific config in `corpdk-main/railway.json`:
- Docker build with watchPatterns for hot reload
- Healthcheck on `/health` endpoint (300s timeout)
- 2 CPU / 4GB memory / 5GB disk
- Asia Southeast region deployment
- Required mount path: `/data`

Environment variables split into:
- `.envvars.json`: Template showing sensitive (KC_DB_*, admin credentials) and railway-specific vars
- Runtime: Database connection details, admin credentials, hostname, port

## Common Commands

### Building the Docker Image
```bash
docker build \
  -f keycloak/Dockerfile \
  --label org.opencontainers.image.revision=$(git rev-parse HEAD) \
  --label org.opencontainers.image.created=$(date -u +%Y-%m-%dT%H:%M:%SZ) \
  -t corpdk-keycloak:latest .
```
```bash
podman build \
  -f keycloak/Dockerfile \
  --label org.opencontainers.image.revision=$(git rev-parse HEAD) \
  --label org.opencontainers.image.created=$(date -u +%Y-%m-%dT%H:%M:%SZ) \
  -t corpdk-keycloak:latest .
```

### Running Locally
```bash
# Set environment variables from .envvars.json first
export KC_DB_URL_HOST=localhost
export KC_DB_URL_PORT=5432
export KC_DB_URL_DATABASE=keycloak
export KC_DB_USERNAME=keycloak
export KC_DB_PASSWORD=password
export KC_BOOTSTRAP_ADMIN_USERNAME=admin
export KC_BOOTSTRAP_ADMIN_PASSWORD=admin
export KC_HOSTNAME=http://localhost:9000
export PORT=9000

# Run with startup script
./startup.sh

# Or run Docker container
docker run -p 9000:9000 --env-file .env corpdk-keycloak:latest
```

### Keycloak Build Commands
```bash
# Inside container - rebuild after adding providers
/opt/keycloak/bin/kc.sh build

# Show current configuration
/opt/keycloak/bin/kc.sh show-config

# Start optimized (production)
/opt/keycloak/bin/kc.sh start --optimized --log-level="INFO"

# Start development mode
/opt/keycloak/bin/kc.sh start-dev
```

## Key Configuration Details

### Database URL Parsing
The `startup.sh` script uses regex to parse Railway's `DATABASE_URL` format:
```
postgres://username:password@host:port/database
```
This is automatically decomposed into individual `KC_DB_*` environment variables.

### Enabled Features
- PostgreSQL database
- Docker feature
- Health endpoint (`/health`)
- Metrics endpoint
- Event metrics for users
- HTTP enabled (behind proxy with `xforwarded` headers)
- IPv6 support

### Proxy Configuration
- `KC_PROXY_HEADERS=xforwarded` - expects X-Forwarded-* headers from Railway's proxy
- `KC_HOSTNAME_BACKCHANNEL_DYNAMIC=true` - dynamic backchannel URL resolution
- `KC_HTTP_ENABLED=true` - HTTP mode (Railway handles TLS termination)

### Performance Tuning
- Connection pool: 1-10 connections
- HTTP max queued requests: 100
- Cache and HTTP metrics histograms enabled
- Transaction manager recovery enabled

## File Structure
- `keycloak/Dockerfile` - Multi-stage build for custom Keycloak image
- `keycloak/theme/keywind/` - Custom theme directory (currently not copied)
- `corpdk-main/railway.json` - Railway deployment configuration
- `startup.sh` - Database URL parser and startup wrapper
- `.envvars.json` - Environment variable template (not for production use)
- `extensions.md` - Documentation of included providers with GitHub links
