#!/bin/sh

set -ouex pipefail

sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-{cisco-openh264,modular,updates-modular}.repo
# Enable the RPM Fusion testing repositories for NVIDIA 535
# https://rpmfind.net/linux/rpm2html/search.php?query=akmod-nvidia
sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/rpmfusion-{free,nonfree}-updates-testing.repo

install -D /tmp/nvidia-addons/rpmbuild/SOURCES/nvidia-container-runtime.repo \
    /etc/yum.repos.d/nvidia-container-runtime.repo

source /var/cache/akmods/nvidia-vars

rpm-ostree install \
    xorg-x11-drv-${NVIDIA_PACKAGE_NAME}-{,cuda-,devel-,kmodsrc-,power-}${NVIDIA_FULL_VERSION} \
    nvidia-container-toolkit nvidia-vaapi-driver \
    /var/cache/akmods/${NVIDIA_PACKAGE_NAME}/kmod-${NVIDIA_PACKAGE_NAME}-${KERNEL_VERSION}-${NVIDIA_AKMOD_VERSION}.fc${RELEASE}.rpm \
    /tmp/nvidia-addons/rpmbuild/RPMS/noarch/nvidia-addons-*.rpm
