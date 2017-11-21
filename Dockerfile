FROM risingstack/alpine:3.4-v8.5.0-4.7.0
LABEL AUTHOR="David Gereb <david.gereb@recart.com>"

ENV FLOW_VERSION=0.39.0
ENV NODE_ENV=development

COPY flow.patch /tmp/flow.patch

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk add --no-cache alpine-sdk ocaml ocamlbuild libelf libelf-dev ncurses inotify-tools linux-headers git bash diffutils \
    && git clone --depth 1 --branch v${FLOW_VERSION} https://github.com/facebook/flow.git /tmp/flow \
    && cd /tmp/flow \
    && cp /tmp/flow.patch . \
    && git apply flow.patch \
    && make -j$(getconf _NPROCESSORS_ONLN)\
    && cp bin/flow /usr/bin/flow \
    && apk del --no-cache alpine-sdk ocaml ocamlbuild libelf-dev ncurses inotify-tools linux-headers git bash diffutils \
    && rm -rf /tmp/* \
    && rm -rf /var/cache/apk/*

CMD ['flow', 'check']