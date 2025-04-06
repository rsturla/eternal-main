#!/usr/bin/env bash

set -euox pipefail

dnf remove -y \
  ffmpeg-free \
  firefox \
  firefox-langpacks
