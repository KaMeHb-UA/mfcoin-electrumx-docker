FROM python:alpine

RUN mkdir -p /var/db/electrumx && \
    apk add --no-cache git build-base openssl && \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/main leveldb-dev && \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing rocksdb-dev && \
    git clone --recursive https://github.com/MFrcoin/electrumx.git && \
    cd electrumx && \
    rm -rf .git && \
    python setup.py install && \
    apk del git build-base && \
    rm -rf /tmp/*

WORKDIR /electrumx

ENTRYPOINT /electrumx/electrumx_server 2>&1 | sh -c 'while read line; do echo "$line"; echo "$line" | grep "INFO:SessionManager:closing down server" && killall python3; done < "${1:-/dev/stdin}"'