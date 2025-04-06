#!/usr/bin/env bash

set -euox pipefail

# Setup Negativo17 repository
dnf config-manager addrepo --from-repofile="https://negativo17.org/repos/fedora-multimedia.repo"
dnf config-manager setopt fedora-multimedia.enabled=1
dnf config-manager setopt fedora-multimedia.priority=90
