#!/usr/bin/env bash

set -euox pipefail

akmods=(
  v4l2loopback
)

# /tmp/akmods/scripts/v4l2loopback/*.sh
for akmod in "${akmods[@]}"; do
  for script in /tmp/akmods/scripts/$akmod/*.sh; do
    if [[ -f "$script" ]]; then
      bash "$script"
    fi
  done
done
