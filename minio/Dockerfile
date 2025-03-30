# Dockerfile for Home Assistant MinIO add-on
ARG BUILD_FROM
FROM $BUILD_FROM

# Add bashio for parsing config.yaml
ENV LANG C.UTF-8

# Install bashio + openssl (for key generation)
RUN apk add --no-cache \
    bash \
    curl \
    jq \
    openssl \
    && curl -sSL -o /usr/local/bin/bashio https://raw.githubusercontent.com/hassio-addons/bashio/master/bashio.sh \
    && chmod +x /usr/local/bin/bashio

# Copy your startup script into the container
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Set entrypoint
CMD [ "/run.sh" ]
