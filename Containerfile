ARG FEDORA_VERSION=38
ARG FEDORA_EDITION=base
ARG FEDORA_IMAGE=quay.io/fedora-ostree-desktops/${FEDORA_EDITION}:${FEDORA_VERSION}

FROM ${FEDORA_IMAGE} as base

COPY files/usr /usr
COPY files/etc /etc

# Enable automatic updates
RUN systemctl enable rpm-ostreed-automatic.timer && \
  systemctl enable flatpak-system-update.timer && \
  systemctl --global enable flatpak-user-update.timer \
  && \
  rm -rf /var/* /tmp/* && \
  ostree container commit
