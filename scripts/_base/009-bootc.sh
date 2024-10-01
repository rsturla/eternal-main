#!/usr/bin/env bash

set -euox pipefail

FEDORA_VERSION=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --version)
      if [[ $# -lt 2 ]]; then
        echo "Error: --version requires a value"
        exit 1
      fi
      FEDORA_VERSION="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1"
      shift 1
      ;;
  esac
done

# Check if FEDORA_VERSION is set and is a valid number
if [[ -z "$FEDORA_VERSION" ]]; then
  echo "Error: --version is required"
  exit 1
fi

if ! [[ "$FEDORA_VERSION" =~ ^[0-9]+$ ]]; then
  echo "Error: --version must be a number"
  exit 1
fi
