# syntax=docker/dockerfile:1

FROM alpine:3.24 AS downloader

ARG TARGETARCH
ARG VERSION=v2.9.6
ARG REALM_AMD64_SHA256=b1cc335547bea8bb2a88178bef12ec7f2363e36200e7ea1d4e1e67627929bf65
ARG REALM_ARM64_SHA256=f4c0318dd86854da483dcb7645b4f39cae2cc3f91c688fef969d53220b949488

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN apk add --no-cache ca-certificates tar wget \
    && case "${TARGETARCH}" in \
         amd64) REALM_ARCH="x86_64-unknown-linux-musl"; REALM_SHA256="${REALM_AMD64_SHA256}" ;; \
         arm64) REALM_ARCH="aarch64-unknown-linux-musl"; REALM_SHA256="${REALM_ARM64_SHA256}" ;; \
         *) echo "Unsupported TARGETARCH: ${TARGETARCH}" >&2; exit 1 ;; \
       esac \
    && wget -qO /tmp/realm.tar.gz "https://github.com/zhboner/realm/releases/download/${VERSION}/realm-${REALM_ARCH}.tar.gz" \
    && echo "${REALM_SHA256}  /tmp/realm.tar.gz" | sha256sum -c - \
    && tar -xzf /tmp/realm.tar.gz -C /tmp \
    && install -m 0755 /tmp/realm /usr/bin/realm

FROM alpine:3.24

ARG VERSION=v2.9.6

LABEL org.opencontainers.image.title="realm" \
      org.opencontainers.image.description="Docker image for realm, a simple high-performance relay server" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.source="https://github.com/zhdsmy/realm" \
      org.opencontainers.image.licenses="MIT"

RUN apk add --no-cache --upgrade ca-certificates libcrypto3 libssl3

COPY --from=downloader /usr/bin/realm /usr/bin/realm

ENTRYPOINT ["/usr/bin/realm"]
