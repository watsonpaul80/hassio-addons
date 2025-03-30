ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

ARG TARGETARCH

RUN apk add --no-cache bash curl jq && \
    case "${TARGETARCH}" in \
      "arm64") ARCH="arm64" ;; \
      "amd64") ARCH="amd64" ;; \
      *) echo "❌ Unsupported architecture: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    echo "✅ Downloading MinIO for $ARCH" && \
    curl -sSLO "https://dl.min.io/server/minio/release/linux-${ARCH}/minio" && \
    chmod +x minio && \
    mv minio /usr/local/bin/minio

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
