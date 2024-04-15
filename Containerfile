ARG FEDORA_VERSION=39
ARG FEDORA_EDITION=base
ARG FEDORA_IMAGE=quay.io/fedora-ostree-desktops/${FEDORA_EDITION}:${FEDORA_VERSION}

# Extract kernel version from CoreOS
FROM quay.io/fedora/fedora-coreos:stable AS coreos-kernel

# e.g. 6.7.7-200.fc39
RUN rpm -qa | grep -oP 'kernel-core-\K[0-9]+\.[0-9]+\.[0-9]+-[0-9]+\.fc[0-9]+' | head -n 1 >> /tmp/kernel-version

FROM ${FEDORA_IMAGE} as base

COPY files/usr /usr
COPY --from=coreos-kernel /tmp/kernel-version /usr/etc/kernel-version

# Replace the kernel version with the one from CoreOS
RUN KERNEL_VERSION=$(cat /usr/etc/kernel-version) && \
  KERNEL_MAJOR_MINOR_PATCH=$(echo $KERNEL_VERSION | cut -d '-' -f 1) && \
  KERNEL_RELEASE=$(echo $KERNEL_VERSION | cut -d '-' -f 2)
  rpm-ostree override replace --experimental \
    https://kojipkgs.fedoraproject.org//packages/kernel/$KERNEL_MAJOR_MINOR_PATCH/$KERNEL_RELEASE/x86_64/kernel-$KERNEL_MAJOR_MINOR_PATCH-$KERNEL_RELEASE.x86_64.rpm \
    https://kojipkgs.fedoraproject.org//packages/kernel/$KERNEL_MAJOR_MINOR_PATCH/$KERNEL_RELEASE/x86_64/kernel-core-$KERNEL_MAJOR_MINOR_PATCH-$KERNEL_RELEASE.x86_64.rpm \
    https://kojipkgs.fedoraproject.org//packages/kernel/$KERNEL_MAJOR_MINOR_PATCH/$KERNEL_RELEASE/x86_64/kernel-modules-$KERNEL_MAJOR_MINOR_PATCH-$KERNEL_RELEASE.x86_64.rpm \
    https://kojipkgs.fedoraproject.org//packages/kernel/$KERNEL_MAJOR_MINOR_PATCH/$KERNEL_RELEASE/x86_64/kernel-modules-core-$KERNEL_MAJOR_MINOR_PATCH-$KERNEL_RELEASE.x86_64.rpm \
    https://kojipkgs.fedoraproject.org//packages/kernel/$KERNEL_MAJOR_MINOR_PATCH/$KERNEL_RELEASE/x86_64/kernel-modules-extra-$KERNEL_MAJOR_MINOR_PATCH-$KERNEL_RELEASE.x86_64.rpm \
  && \
  rm -rf /var/* /tmp/* && \
  ostree container commit

# Setup /etc/bashrc.d
RUN cp /etc/bashrc /usr/etc/bashrc && \
  echo -e "\nfor file in /etc/bashrc.d/*.sh; do\n  source \"\$file\"\ndone\n" >> /usr/etc/bashrc && \
  mkdir -p /usr/etc/bashrc.d \
  && \
  rm -rf /var/* /tmp/* && \
  ostree container commit

# Add udev rules from https://codeberg.org/fabiscafe/game-devices-udev/archive/main.zip
RUN curl -sL https://codeberg.org/fabiscafe/game-devices-udev/archive/main.zip -o /tmp/game-devices-udev.zip && \
  unzip -q /tmp/game-devices-udev.zip -d /tmp && \
  cp -r /tmp/game-devices-udev/* /usr/lib/udev/rules.d/ && \
  mkdir /usr/etc/modules-load.d && \
  echo "uinput" >> /usr/etc/modules-load.d/uinput.conf \
  && \
  rm -rf /var/* /tmp/* && \
  ostree container commit

# Enable cliwrap - wrapper for interfacing with rpm-ostree using dnf/yum/grubby/rpm
RUN rpm-ostree cliwrap install-to-root / \
  && \
  rm -rf /var/* /tmp/* && \
  ostree container commit

# Configure Flatpak
RUN mkdir -p /usr/etc/flatpak/remotes.d && \
  wget -q https://dl.flathub.org/repo/flathub.flatpakrepo -P /usr/etc/flatpak/remotes.d \
  && \
  systemctl enable rpm-ostreed-automatic.timer && \
  systemctl enable flatpak-system-update.timer && \
  systemctl enable flatpak-system-manager.service && \
  systemctl enable setup-system-manager.service && \
  systemctl --global enable flatpak-user-update.timer && \
  systemctl --global enable flatpak-user-manager.service && \
  systemctl --global enable setup-user-manager.service \
  && \
  rm -rf /var/* /tmp/* && \
  ostree container commit

# Configure repositories
RUN rpm-ostree install \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
  rpm-ostree install \
  rpmfusion-nonfree-release  \
  rpmfusion-free-release  \
  --uninstall=rpmfusion-free-release-$(rpm -E %fedora)-1.noarch  \
  --uninstall=rpmfusion-nonfree-release-$(rpm -E %fedora)-1.noarch \
  && \
  sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/fedora-{updates-archive,cisco-openh264}.repo \
  && \
  rm -rf /var/* /tmp/* && \
  ostree container commit

# Remove unwanted packages
RUN rpm-ostree override remove \
  firefox \
  firefox-langpacks \
  libavcodec-free \
  libavfilter-free \
  libavformat-free \
  libavutil-free \
  libpostproc-free \
  libswresample-free \
  libswscale-free \
  && \
  rm -rf /var/* /tmp/* && \
  ostree container commit

# Install packages
RUN rpm-ostree install \
  direnv \
  distrobox \
  ffmpeg \
  ffmpeg-libs \
  htop \
  just \
  neofetch \
  openssl \
  tmux \
  zsh \
  && \
  rm /usr/share/applications/htop.desktop \
  && \
  rm -rf /var/* /tmp/* && \
  ostree container commit
