#!/usr/bin/env bash

set -oeux pipefail

### PREPARE REPOS
ARCH="$(rpm -E '%_arch')"
RELEASE="$(rpm -E '%fedora')"

dnf install -y fedora-repos-archive
curl -L https://negativo17.org/repos/fedora-nvidia.repo \
    -o /etc/yum.repos.d/negativo17-fedora-nvidia.repo

sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-cisco-openh264.repo
sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/fedora-updates-archive.repo

# enable RPMs with alternatives to create them in this image build
mkdir -p /var/lib/alternatives

dnf install -y \
  akmods \
  mock \
  ruby-devel \
  dnf-plugins-core \
  rpmrebuild \
  sbsigntools \
  openssl

gem install fpm --no-user-install --clear-sources

if [[ ! -s "/tmp/certs/private_key.priv" ]]; then
    echo "WARNING: Using test signing key. Run './generate-akmods-key' for production builds."
    cp /tmp/certs/private_key.priv{.local,}
    cp /tmp/certs/public_key.der{.local,}
fi

install -Dm644 /tmp/certs/public_key.der   /etc/pki/akmods/certs/public_key.der
install -Dm644 /tmp/certs/private_key.priv /etc/pki/akmods/private/private_key.priv

# protect against incorrect permissions in tmp dirs which can break akmods builds
chmod 1777 /tmp /var/tmp

# create directories for later copying resulting artifacts
mkdir -p /var/cache/rpms
