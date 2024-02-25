FROM alpine:latest

RUN apk add --no-cache bash curl unzip ca-certificates fuse openssh-client \
  && wget -qO- https://rclone.org/install.sh | bash \
  && apk del bash curl unzip

ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
