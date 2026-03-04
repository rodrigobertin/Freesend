# Docker Deployment

## Quick Start

1. **Configure environment variables:**

   Copy `.env.production` to `.env.production.local` and fill in your values:

   ```bash
   cp .env.production .env.production.local
   ```

   Edit `.env.production.local` with your actual credentials:
   - `AUTH_SECRET` - Generate with: `openssl rand -base64 32`
   - `GOOGLE_CLIENT_ID` - Get from Google Cloud Console
   - `GOOGLE_CLIENT_SECRET` - Get from Google Cloud Console

2. **Build and start:**

   ```bash
   docker-compose up --build
   ```

3. **Access the app:**
   - App: http://localhost:3000
   - PostgreSQL: localhost:5432

## Commands

```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f app

# Stop services
docker-compose down

# Rebuild
docker-compose up --build

# Reset database
docker-compose down -v
docker-compose up --build
```

## Environment Variables

| Variable | Description |
|----------|-------------|
| `NEXT_PUBLIC_APP_URL` | Your app URL |
| `AUTH_SECRET` | NextAuth secret (generate one) |
| `GOOGLE_CLIENT_ID` | Google OAuth Client ID |
| `GOOGLE_CLIENT_SECRET` | Google OAuth Client Secret |
| `POSTGRES_PASSWORD` | PostgreSQL password |
| `DATABASE_URL` | PostgreSQL connection string |

## Production Notes

1. Change the default PostgreSQL password in `.env.production.local`
2. Use a proper domain for `NEXT_PUBLIC_APP_URL`
3. Set up SSL/TLS with a reverse proxy (nginx, Traefik)
4. Update Google OAuth redirect URIs for production
