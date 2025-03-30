ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN apk add --no-cache bash curl jq && \
    ARCH=$(uname -m) && \
    if [ "$ARCH" = "aarch64" ]; then \
        ARCH_DL="arm64"; \
    elif [ "$ARCH" = "x86_64" ]; then \
        ARCH_DL="amd64"; \
    else \
        echo "❌ Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    echo "✅ Downloading MinIO for $ARCH_DL" && \
    curl -sSLO "https://dl.min.io/server/minio/release/linux-${ARCH_DL}/minio" && \
    chmod +x minio && \
    mv minio /usr/local/bin/minio

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
