ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Install dependencies and fetch MinIO based on detected architecture
RUN apk add --no-cache bash curl jq && \
    ARCH=$(uname -m) && \
    if [ "$ARCH" = "aarch64" ]; then ARCH="arm64"; \
    elif [ "$ARCH" = "x86_64" ]; then ARCH="amd64"; \
    else echo "❌ Unsupported architecture: $ARCH" && exit 1; fi && \
    echo "✅ Downloading MinIO for $ARCH" && \
    curl -sSLO "https://dl.min.io/server/minio/release/linux-${ARCH}/minio" && \
    chmod +x minio && \
    mv minio /usr/local/bin/minio

COPY run.sh /run.sh
COPY mc /usr/bin/mc

RUN chmod +x /run.sh /usr/bin/mc

COPY certs/ /etc/ssl/certs/

HEALTHCHECK CMD curl --fail http://localhost:9001/minio/health/live || exit 1

CMD [ "/run.sh" ]
