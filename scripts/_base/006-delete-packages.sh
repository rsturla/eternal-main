#!/usr/bin/env bash

set -euox pipefail

rpm-ostree override remove \
  ffmpeg-free \
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
