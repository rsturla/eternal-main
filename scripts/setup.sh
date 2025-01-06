#!/usr/bin/env bash

set -euo pipefail

FEDORA_EDITION=${FEDORA_EDITION}

for script in /tmp/scripts/_base/*.sh; do
  if [[ -f "$script" ]]; then
    echo "::group::===$(basename "$script")==="
    bash "$script"
    echo "::endgroup::"
  fi
done

# If the edition is BASE, then we don't need to run the same scripts again
if [[ "$FEDORA_EDITION" == "base" ]]; then
  exit 0
fi

for script in /tmp/scripts/_$FEDORA_EDITION/*.sh; do
  if [[ -f "$script" ]]; then
    echo "::group::===$(basename "$script")==="
    bash "$script"
    echo "::endgroup::"
  fi
done
