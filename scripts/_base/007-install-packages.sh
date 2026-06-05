#!/usr/bin/env bash

set -euox pipefail

dnf install -y \
  direnv \
  distrobox \
  ffmpeg \
  ffmpeg-libs \
  fzf \
  gstreamer1-plugin-openh264 \
  htop \
  just \
  openh264 \
  openssl \
  parallel \
  tmux \
  zsh \
  zstd

# Remove unwanted desktop icons
rm /usr/share/applications/htop.desktop
