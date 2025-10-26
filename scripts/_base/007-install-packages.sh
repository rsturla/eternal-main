#!/usr/bin/env bash

set -euox pipefail

dnf install -y \
  direnv \
  distrobox \
  ffmpeg \
  ffmpeg-libs \
  fzf \
  htop \
  just \
  openssl \
  parallel \
  tmux \
  zsh \
  zstd

# Remove unwanted desktop icons
rm /usr/share/applications/htop.desktop
