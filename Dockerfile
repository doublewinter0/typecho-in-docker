FROM php:fpm-alpine

RUN addgroup -S -g 1000 typecho && adduser -S -G typecho -u 999 typecho

ENV TZ Asia/Shanghai
ENV APP typecho

LABEL maintainer="erdong.me@gamil.com"
LABEL version="1.0.0"

RUN apk add --no-cache --virtual .build-deps \
    unzip \
    wget

RUN apk add --no-cache \
    htop \
    postgresql-dev \
    su-exec && \
    docker-php-ext-install pdo pdo_pgsql bcmath

RUN apk del .build-deps

RUN mkdir /app && chown typecho:typecho /app && \
    wget https://github.com/typecho/typecho/archive/refs/heads/master.zip -O /tmp/master.zip && \
    unzip /tmp/master.zip -d /app && \
    mv /app/typecho-master/* /app && \
    rm -rf /app/typecho-master /tmp/master.zip

VOLUME /app

WORKDIR /app

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT [ "docker-entrypoint.sh" ]

EXPOSE 80

CMD [ "php", "-S", "0000:80", "-t", "/app" ]
