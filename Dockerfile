FROM public.ecr.aws/docker/library/node:22-bookworm-slim AS builder

WORKDIR /build

COPY package*.json ./
RUN npm ci --no-audit --no-fund

COPY . .

RUN npm run build
RUN npm ci --omit=dev --no-audit --no-fund

FROM public.ecr.aws/docker/library/node:22-bookworm-slim AS runner

COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.9.1 /lambda-adapter /opt/extensions/lambda-adapter
COPY --from=ghcr.io/rails-lambda/crypteia-extension-debian:2 /opt /opt

ENV NODE_ENV=production
ENV DEBIAN_FRONTEND=noninteractive
ENV APP_PORT=8080
# AWS Lambda Web adapter requirement
ENV AWS_LWA_PORT=$APP_PORT

WORKDIR /usr/src/app
COPY --from=builder --chown=node:node /build ./

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
    && \
    update-ca-certificates --fresh \
    && \
    rm -rf /var/lib/apt/lists/*

EXPOSE $APP_PORT
USER node
ENV LD_PRELOAD=/opt/lib/libcrypteia.so

CMD ["node", "./dist/index.js"]
