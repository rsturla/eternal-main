#!/usr/bin/env bash

set -euox pipefail

akmods=(
  v4l2loopback
)

# /tmp/akmods/scripts/v4l2loopback/*.sh
for akmod in "${akmods[@]}"; do
  if [[ -f "/tmp/akmods/scripts/${akmod}.sh" ]]; then
    bash "/tmp/akmods/scripts/${akmod}.sh"
  else
    echo "Warning: /tmp/akmods/scripts/${akmod}.sh not found."
  fi
done
