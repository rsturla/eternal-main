#!/usr/bin/env bash

set -euox pipefail

dnf group install -y \
  gnome-desktop
