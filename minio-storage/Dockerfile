ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN apk add --no-cache bash curl jq

# Use uname inside a shell
RUN bash -c '\
  ARCH=$(uname -m); \
  if [ "$ARCH" = "aarch64" ]; then MINIO_ARCH="arm64"; \
  elif [ "$ARCH" = "x86_64" ]; then MINIO_ARCH="amd64"; \
  else echo "❌ Unsupported architecture: $ARCH" && exit 1; fi; \
  echo "✅ Downloading MinIO for $MINIO_ARCH"; \
  curl -sSLO https://dl.min.io/server/minio/release/linux-${MINIO_ARCH}/minio && \
  chmod +x minio && \
  mv minio /usr/local/bin/minio'

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
