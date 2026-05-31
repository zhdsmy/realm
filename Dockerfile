# syntax=docker/dockerfile:1

FROM alpine:3.23 AS downloader

ARG TARGETARCH
ARG VERSION=v2.9.4

RUN apk add --no-cache ca-certificates tar wget \
    && case "${TARGETARCH}" in \
         amd64) REALM_ARCH="x86_64-unknown-linux-musl" ;; \
         arm64) REALM_ARCH="aarch64-unknown-linux-musl" ;; \
         *) echo "Unsupported TARGETARCH: ${TARGETARCH}" >&2; exit 1 ;; \
       esac \
    && wget -qO /tmp/realm.tar.gz "https://github.com/zhboner/realm/releases/download/${VERSION}/realm-${REALM_ARCH}.tar.gz" \
    && tar -xzf /tmp/realm.tar.gz -C /tmp \
    && install -m 0755 /tmp/realm /usr/bin/realm

FROM alpine:3.23

ARG VERSION=v2.9.4

LABEL org.opencontainers.image.title="realm" \
      org.opencontainers.image.description="Docker image for realm, a simple high-performance relay server" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.source="https://github.com/zhdsmy/realm" \
      org.opencontainers.image.licenses="MIT"

RUN apk add --no-cache ca-certificates

COPY --from=downloader /usr/bin/realm /usr/bin/realm

ENTRYPOINT ["/usr/bin/realm"]
