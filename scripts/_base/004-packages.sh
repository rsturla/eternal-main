#!/usr/bin/env bash

set -euox pipefail

dnf config-manager --save \
    --setopt=exclude=rootfiles

dnf group install -y \
  -x rsyslog* \
	-x cockpit \
	-x cronie* \
	-x crontabs \
	-x PackageKit \
	-x PackageKit-command-not-found \
  core \
  fonts \
  hardware-support \
  networkmanager-submodules \
  printing \
  standard \
	workstation-product

dnf install -y \
  direnv \
  distrobox \
  ffmpeg \
  ffmpeg-libs \
  fzf \
  htop \
  just \
  openssl \
  tmux \
  unzip \
  zsh \
  zstd

# Remove unwanted desktop icons
rm /usr/share/applications/htop.desktop
