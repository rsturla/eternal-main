#!/usr/bin/env bash

set -euox pipefail

# Setup RPMFusion repositories
rpm-ostree install \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

rpm-ostree install \
  rpmfusion-nonfree-release  \
  rpmfusion-free-release  \
  --uninstall=rpmfusion-free-release-$(rpm -E %fedora)-1.noarch  \
  --uninstall=rpmfusion-nonfree-release-$(rpm -E %fedora)-1.noarch

sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/fedora-{updates-archive,cisco-openh264}.repo

# Install packages
rpm-ostree install \
  bootc \
  bootupd \
  direnv \
  distrobox \
  ffmpeg \
  ffmpeg-libs \
  htop \
  just \
  neofetch \
  openssl \
  tmux \
  zsh

# Remove unwanted desktop icons
rm /usr/share/applications/htop.desktop
