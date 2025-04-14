FROM public.ecr.aws/docker/library/node:22-bookworm-slim AS builder

WORKDIR /build

COPY package*.json ./
RUN npm ci --no-audit --no-fund

COPY . .

RUN npm run build
RUN npm ci --omit=dev --no-audit --no-fund

FROM public.ecr.aws/docker/library/node:22-bookworm-slim AS runner

ENV NODE_ENV=production
ENV APP_PORT=8080

WORKDIR /usr/src/app
COPY --from=builder --chown=node:node /build ./

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

EXPOSE $APP_PORT
USER node
CMD ["node", "./dist/index.js"]
