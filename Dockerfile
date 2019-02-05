FROM ubuntu:xenial AS builder

RUN apt-get update && \
    apt-get install -y zip

COPY src src

RUN mkdir kibana && \
    cp -r src/kibana-cf_authentication kibana/ && \
    zip -r /kibana-auth-plugin.zip kibana/

FROM docker.elastic.co/kibana/kibana-oss:6.4.3

COPY --from=builder /kibana-auth-plugin.zip /kibana-auth-plugin.zip

RUN /usr/share/kibana/bin/kibana-plugin install file:///kibana-auth-plugin.zip
