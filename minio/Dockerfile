ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Required tools
RUN apk add --no-cache bash curl jq

# Download MinIO binary based on architecture
ARG TARGETARCH
RRUN if [ "${TARGETARCH}" = "arm64" ]; then ARCH="arm64"; \
    elif [ "${TARGETARCH}" = "amd64" ]; then ARCH="amd64"; \
    else echo "❌ Unsupported architecture: ${TARGETARCH}" && exit 1; fi && \
    curl -sSLO "https://dl.min.io/server/minio/release/linux-${ARCH}/minio" && \
    chmod +x minio && \
    mv minio /usr/local/bin/

# Add run script
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
