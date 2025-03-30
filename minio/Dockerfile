ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN apk add --no-cache bash curl jq

# Detect architecture at runtime using uname
RUN ARCH=$(uname -m | sed 's/aarch64/arm64/;s/x86_64/amd64/') && \
    curl -sSLO "https://dl.min.io/server/minio/release/linux-${ARCH}/minio" && \
    chmod +x minio && \
    mv minio /usr/local/bin/


COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
