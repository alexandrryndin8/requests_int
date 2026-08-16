# syntax=docker/dockerfile:1

##########################
# Stage 1: dependencies + build
##########################
FROM node:20-bookworm-slim AS builder

# bcrypt is a native addon — need a C++ toolchain to compile it during npm ci
RUN apt-get update \
  && apt-get install -y --no-install-recommends python3 make g++ \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install deps first (better layer caching)
COPY package.json package-lock.json ./
RUN npm ci

# Copy the rest of the source and build
COPY . .

# prisma generate needs the schema, not a live DB connection
RUN npx prisma generate

RUN npm run build

##########################
# Stage 2: production runtime
##########################
FROM node:20-bookworm-slim AS runner

ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=3000

WORKDIR /app

# Non-root user to run the app
RUN groupadd --system --gid 1001 nodejs \
  && useradd --system --uid 1001 --gid nodejs nuxtuser

# Nuxt's node-server output is self-contained: it bundles its own
# node_modules (including the generated Prisma client) inside .output
COPY --from=builder --chown=nuxtuser:nodejs /app/.output ./.output

USER nuxtuser

EXPOSE 3000

CMD ["node", ".output/server/index.mjs"]
