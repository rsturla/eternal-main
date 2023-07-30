ARG FEDORA_VERSION=38
ARG FEDORA_EDITION=base
ARG FEDORA_IMAGE=quay.io/fedora-ostree-desktops/${FEDORA_EDITION}:${FEDORA_VERSION}

FROM ${FEDORA_IMAGE} as base

COPY files/usr /usr
COPY files/etc /etc

# Create /var/tmp directory
RUN mkdir -p /var/tmp && chmod -R 1777 /var/tmp

# Enable automatic updates
RUN systemctl enable rpm-ostreed-automatic.timer && \
  systemctl enable flatpak-system-update.timer && \
  systemctl --global enable flatpak-user-update.timer \
  && \
  rm -rf /tmp/* && \
  ostree container commit

# Install RPMFusion repositories
RUN rpm-ostree install \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
  rpm-ostree install \
  rpmfusion-nonfree-release  \
  rpmfusion-free-release  \
  --uninstall=rpmfusion-free-release-$(rpm -E %fedora)-1.noarch  \
  --uninstall=rpmfusion-nonfree-release-$(rpm -E %fedora)-1.noarch \
  && \
  rm -rf /tmp/* && \
  ostree container commit

# Remove unwanted packages
RUN rpm-ostree override remove \
  firefox \
  firefox-langpacks \
  && \
  rm -rf /tmp/* && \
  ostree container commit

# Install Mesa VA drivers
RUN rpm-ostree override remove \
  mesa-va-drivers && \
  rpm-ostree install \
  mesa-va-drivers-freeworld \
  && \
  rm -rf /tmp/* && \
  ostree container commit

# Install packages
RUN rpm-ostree install \
  chromium \
  distrobox \
  just \
  neofetch \
  openssl \
  tmux \
  zsh \
  htop \
  && \
  rm -rf /tmp/* && \
  ostree container commit
