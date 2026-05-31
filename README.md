# realm

Docker image for [realm](https://github.com/zhboner/realm), a simple high-performance relay server.

[![Docker Pulls](https://img.shields.io/docker/pulls/domizhang/realm.svg)](https://hub.docker.com/r/domizhang/realm)
[![Docker Image Size](https://img.shields.io/docker/image-size/domizhang/realm/latest)](https://hub.docker.com/r/domizhang/realm)

## Included version

- realm: `v2.9.4`
- Base image: `alpine:3.23`

## Supported platforms

- `linux/amd64`
- `linux/arm64`

## Tags

- `latest`: latest build from the default branch
- `2.9.4`: current realm version build
- `2.9`: major/minor tag for versioned releases

## Quick start

Show the realm help output:

```bash
docker run --rm domizhang/realm:latest --help
```

Run with a config file:

```bash
docker run -d \
  --name realm \
  -p 5000:5000/tcp \
  -p 5000:5000/udp \
  -v "$PWD/realm.toml:/etc/realm.toml:ro" \
  domizhang/realm:latest \
  -c /etc/realm.toml
```

## Docker Compose

```yaml
services:
  realm:
    image: domizhang/realm:latest
    container_name: realm
    restart: unless-stopped
    ports:
      - "5000:5000/tcp"
      - "5000:5000/udp"
    volumes:
      - ./realm.toml:/etc/realm.toml:ro
    command: ["-c", "/etc/realm.toml"]
```

## Build locally

```bash
docker build \
  --build-arg VERSION=v2.9.4 \
  -t domizhang/realm:local .
```

## Update policy

The realm version is pinned in `Dockerfile` and `.github/workflows/main.yml`. To update:

1. Check the upstream [realm releases](https://github.com/zhboner/realm/releases).
2. Update `VERSION` / `DEFAULT_VERSION`.
3. Build and test the image.
4. Tag the repository as `vX.Y.Z` to publish versioned tags.

## License

This repository only builds a Docker image. realm is distributed under its upstream license.
