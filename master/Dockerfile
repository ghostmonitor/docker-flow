FROM alpine:edge

MAINTAINER Sébastien HOUZÉ <sebastien.houze@verylastroom.com>

COPY flow.patch /tmp/

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --no-cache --virtual .build-deps \
        alpine-sdk \
        ocaml \
        libelf \
        libelf-dev \
        ncurses \
        inotify-tools \
        linux-headers \
        bash \
        diffutils \
        git \
    && cd /tmp \
    && git clone --depth=1 https://github.com/facebook/flow.git /tmp/flow \
    && cd /tmp/flow \
    && cp /tmp/flow.patch . \
    && git apply flow.patch \
    && make -j"$(getconf _NPROCESSORS_ONLN)" \
    && cp /tmp/flow/bin/flow /usr/local/bin \
    && runDeps="$( \
        scanelf --needed --nobanner --recursive /usr/local \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | sort -u \
            | xargs -r apk info --installed \
            | sort -u \
    )" \
    && apk add --no-cache --virtual .flow-rundeps $runDeps \
    && apk del --no-cache .build-deps \
    && rm -rf /tmp/*

VOLUME /app
WORKDIR /app

CMD ["flow", "check"]
