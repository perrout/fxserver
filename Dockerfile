FROM alpine AS artifacts
RUN apk update --no-cache && apk add --no-cache ca-certificates curl
RUN curl https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/5848-4f71128ee48b07026d6d7229a60ebc5f40f2b9db/fx.tar.xz | tar xJ -C /srv/.

FROM alpine
RUN apk update --no-cache && apk add --no-cache \
    ca-certificates \
    curl \
    nodejs \
    yarn \
    zip \
    unzip

COPY --from=artifacts /srv/. /opt/cfx-server/server
# COPY --chown=1000:1000 ./config /opt/cfx-server/config
COPY ./server-data /opt/cfx-server/server-data

ADD ./entrypoint /usr/bin/entrypoint
RUN chmod +x /usr/bin/entrypoint

WORKDIR /opt/cfx-server/server-data

EXPOSE 30120/tcp 30120/udp

ENTRYPOINT ["/usr/bin/entrypoint"]