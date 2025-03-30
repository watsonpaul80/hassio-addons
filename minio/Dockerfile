ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN apk add --no-cache bash curl jq

# Download latest MinIO binary (ARM64 or AMD64 auto-matched by HA build)
RUN curl -sSLO https://dl.min.io/server/minio/release/linux-amd64/minio \
  && chmod +x minio \
  && mv minio /usr/local/bin/

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
