#!/usr/bin/env bash

set -euox pipefail

mkdir -p /usr/etc/flatpak/remotes.d
wget -q https://dl.flathub.org/repo/flathub.flatpakrepo -P /usr/etc/flatpak/remotes.d

systemctl enable rpm-ostreed-automatic.timer

systemctl enable flatpak-system-update.timer
systemctl enable setup-system-manager.service
systemctl --global enable flatpak-user-update.timer
systemctl --global enable setup-user-manager.service
