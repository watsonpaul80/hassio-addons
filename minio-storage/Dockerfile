ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Install required packages
RUN apk add --no-cache bash curl jq

# Detect architecture at runtime instead of build-time
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
