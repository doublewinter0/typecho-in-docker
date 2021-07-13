#!/bin/sh

set -e

if [[ "$1" = 'php' && "$(id -u)" = '0' ]]; then
    find . \! -user typecho -exec chown typecho:typecho '{}' +
    echo "starting ${APP}..."
    exec su-exec typecho "$@"
fi

echo "starting ${APP}..."
exec "$@"
