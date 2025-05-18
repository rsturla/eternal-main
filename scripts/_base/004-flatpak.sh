#!/usr/bin/env bash

set -euox pipefail

mkdir -p /etc/flatpak/remotes.d
curl -sSL https://dl.flathub.org/repo/flathub.flatpakrepo -o /etc/flatpak/remotes.d/flathub.flatpakrepo

systemctl enable rpm-ostreed-automatic.timer

systemctl enable flatpak-system-update.timer
systemctl enable setup-system-manager.service
systemctl --global enable flatpak-user-update.timer
systemctl --global enable setup-user-manager.service
