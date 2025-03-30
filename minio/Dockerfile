ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

ARG TARGETARCH

# Install dependencies and fetch appropriate MinIO binary
RUN apk add --no-cache bash curl jq && \
    case "$TARGETARCH" in \
      "arm64") ARCH="arm64" ;; \
      "amd64") ARCH="amd64" ;; \
      *) echo "❌ Unsupported architecture: $TARGETARCH" && exit 1 ;; \
    esac && \
    echo "✅ Downloading MinIO for $ARCH" && \
    curl -sSLO "https://dl.min.io/server/minio/release/linux-${ARCH}/minio" && \
    chmod +x minio && \
    mv minio /usr/local/bin/minio

# Copy run script and optional MinIO Client (mc)
COPY run.sh /run.sh
COPY mc /usr/bin/mc

RUN chmod +x /run.sh /usr/bin/mc

# Optional: Add SSL certs (optional user-provided)
COPY certs/ /etc/ssl/certs/

# Health check endpoint (for Home Assistant watchdog)
HEALTHCHECK CMD curl --fail http://localhost:9001/minio/health/live || exit 1

# Entrypoint
CMD [ "/run.sh" ]
