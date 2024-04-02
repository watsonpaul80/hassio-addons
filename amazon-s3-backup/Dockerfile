FROM alpine:3.17

ENV LANG C.UTF-8

COPY run.sh /

RUN chmod a+x /run.sh && \
    apk add -v --update --no-cache \
      coreutils \
      python3 \
      py3-pip \
      groff \
      less \
      jq && \
    pip3 install --no-cache-dir --upgrade awscli

LABEL maintainer="Paul Watson watsonpaul80@gmail.com" \
      version="1.0" \
      description="Amazon S3 Backup Addon for Home Assistant"

CMD ["/run.sh"]