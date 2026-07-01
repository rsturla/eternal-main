#!/usr/bin/env bash

set -euo pipefail

# Add COPR repo (disabled by default)
cat > /etc/yum.repos.d/rsturla-devel.repo <<'EOF'
[copr:copr.fedorainfracloud.org:rsturla:devel]
name=Copr repo for devel owned by rsturla
baseurl=https://download.copr.fedorainfracloud.org/results/rsturla/devel/fedora-$releasever-$basearch/
type=rpm-md
skip_if_unavailable=True
gpgcheck=1
gpgkey=https://download.copr.fedorainfracloud.org/results/rsturla/devel/pubkey.gpg
repo_gpgcheck=0
enabled=0
enabled_metadata=1
EOF

# Download and install new RPM with jsonzstd support
dnf download \
  --enablerepo=copr:copr.fedorainfracloud.org:rsturla:devel \
  --from-repo=copr:copr.fedorainfracloud.org:rsturla:devel \
  -y rpm rpm-libs rpm-sign-libs rpm-build-libs rpm-plugin-audit rpm-plugin-selinux \
  --destdir=/tmp

rm -f /tmp/*.src.rpm
rpm -Uvh --force /tmp/rpm-*.rpm

# Find actual RPM database directory
for dir in /usr/lib/sysimage/rpm /usr/share/rpm /var/lib/rpm; do
  if [ -d "$dir" ] && [ -f "$dir/rpmdb.sqlite" ]; then
    RPM_DB_DIR="$dir"
    break
  fi
done

echo "Using RPM database at: $RPM_DB_DIR"

# Rebuild database (convert sqlite -> jsonzstd)
if ! rpm --rebuilddb 2>/dev/null; then
  # Handle overlayfs limitation: manual rename
  REBUILD_DIR=$(find /usr/lib/sysimage /var/lib /usr/share -maxdepth 1 -name 'rpmrebuilddb.*' -type d 2>/dev/null | head -n1)

  if [ -n "$REBUILD_DIR" ]; then
    rm -rf "$RPM_DB_DIR"
    cp -a "$REBUILD_DIR" "$RPM_DB_DIR"
    rm -rf "$REBUILD_DIR"
  else
    echo "ERROR: Database rebuild failed"
    exit 1
  fi
fi

# Clean up old sqlite files from ALL possible locations
for dir in /usr/lib/sysimage/rpm /usr/share/rpm /var/lib/rpm; do
  if [ -d "$dir" ]; then
    rm -f "$dir"/rpmdb.sqlite*
  fi
done

ls -la /usr/share/rpm/
ls -la /usr/share/rpm/jsonzstd/

# Clean up COPR repo
rm -f /etc/yum.repos.d/rsturla-devel.repo

echo "RPM database converted to jsonzstd"
