FROM alpine:latest

ARG TARGETARCH
ARG VERSION=v2.9.1

WORKDIR /realm

RUN if [ "$TARGETARCH" = "arm64" ] ; then \
    wget https://github.com/zhboner/realm/releases/download/${VERSION}/realm-aarch64-unknown-linux-musl.tar.gz \
    && tar -zxvf realm-aarch64-unknown-linux-musl.tar.gz \
    && cp realm /usr/bin/realm \
    && chmod +x /usr/bin/realm; \
    else \
    wget https://github.com/zhboner/realm/releases/download/${VERSION}/realm-x86_64-unknown-linux-musl.tar.gz \
    && tar -zxvf realm-x86_64-unknown-linux-musl.tar.gz \
    && cp realm /usr/bin/realm \
    && chmod +x /usr/bin/realm; \
    fi

ENTRYPOINT ["/usr/bin/realm"]