#!/usr/bin/env bash

set -euox pipefail

dnf group install -y \
  cosmic-desktop \
  cosmic-desktop-apps
