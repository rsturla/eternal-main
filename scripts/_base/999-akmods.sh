#!/usr/bin/env bash

set -euox pipefail

AKMODS_DIR="/buildcontext/akmods"

akmods=(
  v4l2loopback
)

# Loop through scripts for each akmod
for akmod in "${akmods[@]}"; do
  for script in "${AKMODS_DIR}/${akmod}/scripts/"*.sh; do
    if [[ -f "$script" ]]; then
      bash "$script" "${AKMODS_DIR}/${akmod}"
    fi
  done
done
