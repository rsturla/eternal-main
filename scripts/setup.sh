#!/usr/bin/env bash

set -euo pipefail

DESKTOP_ENVIRONMENT=${DESKTOP_ENVIRONMENT}

# Get the directory of the current script
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

# Run base scripts
for script in "$SCRIPT_DIR"/_base/*.sh; do
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

# Run environment-specific scripts
for script in "$SCRIPT_DIR"/_"$DESKTOP_ENVIRONMENT"/*.sh; do
  if [[ -f "$script" ]]; then
    echo "::group::===$(basename "$script")==="
    bash "$script"
    echo "::endgroup::"
  fi
done
