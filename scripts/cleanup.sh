#!/usr/bin/env bash

set -euox pipefail

sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/rpmfusion-{free,nonfree}{,-updates,-updates-testing}.repo

# Generate initramfs
mkdir -p /var/tmp
KERNEL_SUFFIX=""
QUALIFIED_KERNEL="$(rpm -qa | grep -P 'kernel-(|'"$KERNEL_SUFFIX"'-)(\d+\.\d+\.\d+)' | sed -E 's/kernel-(|'"$KERNEL_SUFFIX"'-)//')"
/usr/libexec/rpm-ostree/wrapped/dracut --no-hostonly --kver "$QUALIFIED_KERNEL" --reproducible -v --add ostree -f "/lib/modules/$QUALIFIED_KERNEL/initramfs.img"
