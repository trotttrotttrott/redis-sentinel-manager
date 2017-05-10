FROM alpine:3.5

WORKDIR /opt/redis-sentinel-manager

RUN apk add --update ruby ruby-json less && \
    rm -rf /var/cache/apk/* && \
    gem install diplomat:1.3.0 redis:3.3.3 --no-rdoc --no-ri

COPY redis-sentinel-manager /opt/redis-sentinel-manager/bin/

ENV REDIS_MASTERS MASTER_CONSUL_SERVICE_PREFIX SENTINEL_SERVICE QUORUM CONSUL_HOST CHECK_PORT INTERVAL

CMD bin/redis-sentinel-manager
