ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Install bashio correctly
RUN apk add --no-cache bash curl jq openssl \
    && curl -sSL -o /usr/lib/bashio.sh https://raw.githubusercontent.com/hassio-addons/bashio/master/bashio.sh \
    && chmod +x /usr/lib/bashio.sh

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
