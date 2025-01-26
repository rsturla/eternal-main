#!/bin/sh

set -oeux pipefail

RELEASE="$(rpm -E '%fedora.%_arch')"

# Build NVIDIA drivers
dnf install -y \
    akmod-nvidia*.fc${RELEASE}

KERNEL_VERSION="$(rpm -q kernel-core --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"
NVIDIA_AKMOD_VERSION="$(basename "$(rpm -q "akmod-nvidia" --queryformat '%{VERSION}-%{RELEASE}')" ".fc${RELEASE%%.*}")"

# Build the open source kernel module
sed -i "s/^MODULE_VARIANT=.*/MODULE_VARIANT=kernel-open/" /etc/nvidia/kernel.conf

akmods --force --kernels "${KERNEL_VERSION}" --kmod "nvidia"

modinfo /usr/lib/modules/${KERNEL_VERSION}/extra/nvidia/nvidia{,-drm,-modeset,-peermem,-uvm}.ko.xz > /dev/null || \
(cat /var/cache/akmods/nvidia/${NVIDIA_AKMOD_VERSION}-for-${KERNEL_VERSION}.failed.log && exit 1)

# View license information
modinfo -l /usr/lib/modules/${KERNEL_VERSION}/extra/nvidia/nvidia{,-drm,-modeset,-peermem,-uvm}.ko.xz

# Build nvidia-addons
ADDONS_DIR="/tmp/rpm-specs/nvidia-addons"
mkdir -p ${ADDONS_DIR}/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS,tmp}
curl -Lo ${ADDONS_DIR}/rpmbuild/SOURCES/nvidia-container-toolkit.repo https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo
curl -Lo ${ADDONS_DIR}/rpmbuild/SOURCES/nvidia-container.pp https://raw.githubusercontent.com/NVIDIA/dgx-selinux/master/bin/RHEL9/nvidia-container.pp
cp /etc/yum.repos.d/negativo17-fedora-nvidia.repo ${ADDONS_DIR}/rpmbuild/SOURCES/negativo17-fedora-nvidia.repo
mv /tmp/files/* ${ADDONS_DIR}/rpmbuild/SOURCES/

sed -i "s@gpgcheck=0@gpgcheck=1@" ${ADDONS_DIR}/rpmbuild/SOURCES/nvidia-container-toolkit.repo

install -D /etc/pki/akmods/certs/public_key.der ${ADDONS_DIR}/rpmbuild/SOURCES/public_key.der

rpmbuild -ba \
    --define "_topdir ${ADDONS_DIR}/rpmbuild" \
    --define '%_tmppath %{_topdir}/tmp' \
    ${ADDONS_DIR}/../nvidia-addons.spec

mkdir -p /var/cache/rpms

for rpm in $(find /var/cache/akmods/ -type f -name \*.rpm); do
    cp "${rpm}" /var/cache/rpms/;
done

for rpm in $(find ${ADDONS_DIR}/rpmbuild/RPMS/"$(uname -m)"/ -type f -name \*.rpm); do
    cp "${rpm}" /var/cache/rpms/;
done

for rpm in $(find ${ADDONS_DIR}/rpmbuild/RPMS/noarch/ -type f -name \*.rpm); do
    cp "${rpm}" /var/cache/rpms/;
done

find /var/cache/rpms

# Create a file with the variables needed for the next steps
cat <<EOF > /var/cache/akmods/nvidia-vars
KERNEL_VERSION=${KERNEL_VERSION}
RELEASE=${RELEASE}
NVIDIA_AKMOD_VERSION=${NVIDIA_AKMOD_VERSION}
EOF
