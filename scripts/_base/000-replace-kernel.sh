#!/usr/bin/env bash

set -euox pipefail

COREOS_KERNEL=""
FEDORA_VERSION=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --version)
      FEDORA_VERSION="$2"
      shift 2
      ;;
    --coreos-kernel)
      if [[ "$2" == "" || "$2" == --* ]]; then
        COREOS_KERNEL=""
        shift 1
      else
        COREOS_KERNEL="$2"
        shift 2
      fi
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

if [[ "$COREOS_KERNEL" == "" ]]; then
  exit 0
fi

KERNEL_VERSION=$COREOS_KERNEL
KERNEL_MAJOR_MINOR_PATCH=$(echo $KERNEL_VERSION | cut -d '-' -f 1)
KERNEL_RELEASE=$(echo $KERNEL_VERSION | cut -d '-' -f 2)
rpm-ostree override replace --experimental \
    https://kojipkgs.fedoraproject.org//packages/kernel/$KERNEL_MAJOR_MINOR_PATCH/$KERNEL_RELEASE/x86_64/kernel-$KERNEL_MAJOR_MINOR_PATCH-$KERNEL_RELEASE.x86_64.rpm \
    https://kojipkgs.fedoraproject.org//packages/kernel/$KERNEL_MAJOR_MINOR_PATCH/$KERNEL_RELEASE/x86_64/kernel-core-$KERNEL_MAJOR_MINOR_PATCH-$KERNEL_RELEASE.x86_64.rpm \
    https://kojipkgs.fedoraproject.org//packages/kernel/$KERNEL_MAJOR_MINOR_PATCH/$KERNEL_RELEASE/x86_64/kernel-modules-$KERNEL_MAJOR_MINOR_PATCH-$KERNEL_RELEASE.x86_64.rpm \
    https://kojipkgs.fedoraproject.org//packages/kernel/$KERNEL_MAJOR_MINOR_PATCH/$KERNEL_RELEASE/x86_64/kernel-modules-core-$KERNEL_MAJOR_MINOR_PATCH-$KERNEL_RELEASE.x86_64.rpm \
    https://kojipkgs.fedoraproject.org//packages/kernel/$KERNEL_MAJOR_MINOR_PATCH/$KERNEL_RELEASE/x86_64/kernel-modules-extra-$KERNEL_MAJOR_MINOR_PATCH-$KERNEL_RELEASE.x86_64.rpm
