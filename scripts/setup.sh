#!/usr/bin/env bash

set -euo pipefail

DESKTOP_ENVIRONMENT=${DESKTOP_ENVIRONMENT}

for script in /tmp/scripts/_base/*.sh; do
  if [[ -f "$script" ]]; then
    echo "::group::===$(basename "$script")==="
    bash "$script"
    echo "::endgroup::"
  fi
done

# If the edition is BASE, then we don't need to run the same scripts again
if [[ "$DESKTOP_ENVIRONMENT" == "base" ]]; then
  exit 0
fi

for script in /tmp/scripts/_$DESKTOP_ENVIRONMENT/*.sh; do
  if [[ -f "$script" ]]; then
    echo "::group::===$(basename "$script")==="
    bash "$script"
    echo "::endgroup::"
  fi
done
