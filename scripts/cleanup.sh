#!/usr/bin/env bash

set -euox pipefail

dnf config-manager unsetopt exclude
sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/rpmfusion-{free,nonfree}{,-updates,-updates-testing}.repo

# Generate initramfs
mkdir -p /var/tmp
KERNEL_SUFFIX=""
QUALIFIED_KERNEL="$(rpm -qa | grep -P 'kernel-(|'"$KERNEL_SUFFIX"'-)(\d+\.\d+\.\d+)' | sed -E 's/kernel-(|'"$KERNEL_SUFFIX"'-)//')"
/usr/bin/dracut --no-hostonly --kver "$QUALIFIED_KERNEL" --reproducible -v --add ostree -f "/lib/modules/$QUALIFIED_KERNEL/initramfs.img"

# Clear out unsupported directories
rm -rf /tmp/* /var/*
