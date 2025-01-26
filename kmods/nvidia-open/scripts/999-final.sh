#!/usr/bin/env bash

set -oeux pipefail

mkdir -p /rpms
for rpm in $(find /var/cache/rpms -name '*.rpm'); do
  echo "Copying $rpm..."
  cp -a $rpm /rpms
done

kernel_version=$(rpm -q --qf "%{VERSION}-%{RELEASE}.%{ARCH}\n" kernel-core | head -n 1)

sed -i -e 's/args = \["rpmbuild", "-bb"\]/args = \["rpmbuild", "-bb", "--buildroot", "#{build_path}\/BUILD"\]/g' /usr/local/share/gems/gems/fpm-*/lib/fpm/package/rpm.rb;

for rpm in $(find /rpms -type f -name \*.rpm); do
  basename="$(basename ${rpm})"
  # Remove kernel version from the RPM name (e.g. kmod-nvidia-6.11.3-300.fc41.x86_64-3:560.35.03-2.fc41.x86_64 -> kmod-nvidia-3:560.35.03-2.fc41.x86_64)
  name=$(echo ${basename} | sed -r "s/(-${kernel_version})//g")

  if [[ "$basename" == *"$kernel_version"* ]]; then
    echo "Processing $rpm with kernel version $kernel_version..."
    fpm --verbose -s rpm -t rpm -p ${rpm} -f --name ${name} ${rpm};
  else
    echo "Skipping $rpm as it does not contain kernel version $kernel_version..."
  fi
done

ls -l /rpms
