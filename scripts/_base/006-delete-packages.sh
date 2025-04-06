#!/usr/bin/env bash

set -euox pipefail

dnf remove -y \
  firefox \
  firefox-langpacks \
  libavcodec-free \
  libavdevice-free \
  libavfilter-free \
  libavformat-free \
  libavutil-free \
  libpostproc-free \
  libswresample-free \
  libswscale-free
