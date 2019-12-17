FROM python:alpine

RUN mkdir -p /var/db/electrumx && \
    apk add --no-cache git build-base openssl && \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/main leveldb leveldb-dev && \
    git clone --recursive https://github.com/MFrcoin/electrumx.git && \
    cd electrumx && \
    rm -rf .git && \
    python setup.py install && \
    apk del git build-base leveldb-dev && \
    rm -rf /tmp/*

WORKDIR /electrumx

ENTRYPOINT /electrumx/electrumx_server 2>&1 | sh -c 'while read line; do echo "$line"; echo "$line" | grep "INFO:SessionManager:closing down server" && killall python3; done < "${1:-/dev/stdin}"'
