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
  openssl \
  tmux \
  zsh \
  zstd

# Remove unwanted desktop icons
rm /usr/share/applications/htop.desktop

# Setup Git LFS
git lfs install
