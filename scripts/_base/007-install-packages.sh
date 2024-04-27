#!/usr/bin/env bash

set -euox pipefail

rpm-ostree install \
  bootc \
  bootupd \
  direnv \
  distrobox \
  ffmpeg \
  ffmpeg-libs \
  fzf \
  htop \
  just \
  neofetch \
  openssl \
  tmux \
  zsh

# Remove unwanted desktop icons
rm /usr/share/applications/htop.desktop
