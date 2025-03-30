ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Install needed packages
RUN apk add --no-cache \
    bash \
    curl \
    jq \
    openssl \
    minio

# Copy run script
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
