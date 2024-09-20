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
      COREOS_KERNEL="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

if [[ "$COREOS_KERNEL" == "N/A" ]]; then
  exit 0
fi

KERNEL_VERSION=$COREOS_KERNEL
KERNEL_MAJOR_MINOR_PATCH=$(echo $KERNEL_VERSION | cut -d '-' -f 1)
KERNEL_RELEASE=$(echo $KERNEL_VERSION | cut -d '-' -f 2 | rev | cut -d '.' -f 2- | rev)
ARCH=$(uname -m)
rpm-ostree override replace --experimental \
    https://kojipkgs.fedoraproject.org//packages/kernel/$KERNEL_MAJOR_MINOR_PATCH/$KERNEL_RELEASE/$ARCH/kernel-$KERNEL_MAJOR_MINOR_PATCH-$KERNEL_RELEASE.$ARCH.rpm \
    https://kojipkgs.fedoraproject.org//packages/kernel/$KERNEL_MAJOR_MINOR_PATCH/$KERNEL_RELEASE/$ARCH/kernel-core-$KERNEL_MAJOR_MINOR_PATCH-$KERNEL_RELEASE.$ARCH.rpm \
    https://kojipkgs.fedoraproject.org//packages/kernel/$KERNEL_MAJOR_MINOR_PATCH/$KERNEL_RELEASE/$ARCH/kernel-modules-$KERNEL_MAJOR_MINOR_PATCH-$KERNEL_RELEASE.$ARCH.rpm \
    https://kojipkgs.fedoraproject.org//packages/kernel/$KERNEL_MAJOR_MINOR_PATCH/$KERNEL_RELEASE/$ARCH/kernel-modules-core-$KERNEL_MAJOR_MINOR_PATCH-$KERNEL_RELEASE.$ARCH.rpm \
    https://kojipkgs.fedoraproject.org//packages/kernel/$KERNEL_MAJOR_MINOR_PATCH/$KERNEL_RELEASE/$ARCH/kernel-modules-extra-$KERNEL_MAJOR_MINOR_PATCH-$KERNEL_RELEASE.$ARCH.rpm
