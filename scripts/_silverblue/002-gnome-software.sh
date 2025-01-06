#!/usr/bin/env bash

set -euox pipefail

wget https://copr.fedorainfracloud.org/coprs/ublue-os/staging/repo/fedora-$(rpm -E %fedora)/ublue-os-staging-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_ublue-os_staging.repo

dnf remove -y \
  gnome-software-rpm-ostree

dnf remove -y \
  gnome-software

dnf install -y \
  --repo=copr:copr.fedorainfracloud.org:ublue-os:staging \
  gnome-software

rm -rf /etc/yum.repos.d/_copr_ublue-os_staging.repo
