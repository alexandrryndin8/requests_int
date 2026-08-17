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

# Install deps first (better layer caching).
# The prisma schema must be present before npm ci runs, because the
# package.json "postinstall" script (nuxt prepare && prisma generate)
# fires automatically during npm ci and needs prisma/schema.prisma to exist.
COPY package.json package-lock.json ./
COPY prisma ./prisma
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

# node:*-bookworm-slim doesn't include OpenSSL by default, but the Prisma
# query engine needs libssl at runtime to load — without this it fails with
# a confusing "add binaryTargets to schema.prisma" error that is really
# just a missing shared library.
RUN apt-get update \
  && apt-get install -y --no-install-recommends openssl \
  && rm -rf /var/lib/apt/lists/*

# Non-root user to run the app
RUN groupadd --system --gid 1001 nodejs \
  && useradd --system --uid 1001 --gid nodejs nuxtuser

# nuxt.config.ts explicitly marks @prisma/client (and its generated .prisma
# engine) as external to the Nitro/Rollup bundle — it contains a native
# binary that can't be bundled — so .output is NOT self-contained for
# Prisma and these packages must be copied separately.
COPY --from=builder --chown=nuxtuser:nodejs /app/.output ./.output
COPY --from=builder --chown=nuxtuser:nodejs /app/node_modules/@prisma ./node_modules/@prisma
COPY --from=builder --chown=nuxtuser:nodejs /app/node_modules/.prisma ./node_modules/.prisma

USER nuxtuser

EXPOSE 3000

CMD ["node", ".output/server/index.mjs"]
