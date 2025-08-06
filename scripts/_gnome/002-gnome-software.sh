#!/usr/bin/env bash

set -euox pipefail

dnf -y copr enable ublue-os/staging

dnf remove -y \
  gnome-software-rpm-ostree

rm -rf /etc/yum.repos.d/_copr_ublue-os_staging.repo
