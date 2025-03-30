ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Install bashio correctly + required tools
RUN apk add --no-cache \
    bash \
    curl \
    jq \
    openssl \
    && wget -O /usr/lib/bashio.sh https://raw.githubusercontent.com/hassio-addons/bashio/master/bashio.sh \
    && chmod +x /usr/lib/bashio.sh

# Copy run script
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
