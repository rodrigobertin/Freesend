# ---- Dependencies ----
FROM node:18-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm ci

# ---- Builder ----
FROM node:18-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Generate Prisma Client
RUN npx prisma generate

# Build the Next.js app
RUN npm run build

# ---- Runner ----
FROM node:18-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/env.mjs ./

USER nextjs

COPY --from=builder /app/scripts ./scripts

EXPOSE 3000
ENV PORT=3000
ENV NEXT_PUBLIC_APP_URL=http://localhost:3000

# Run Prisma migrations and start the server
CMD ["sh", "-c", "npx prisma generate && npx prisma db push && node server.js"]
