#!/usr/bin/env bash

set -euox pipefail

# Setup RPMFusion repositories
dnf install -y \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/fedora-{updates-archive,cisco-openh264}.repo
