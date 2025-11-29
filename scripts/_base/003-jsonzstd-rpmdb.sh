#!/usr/bin/env bash

set -euox pipefail

# Add rsturla/devel COPR repo configuration, disabled by default
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

dnf download --enablerepo=copr:copr.fedorainfracloud.org:rsturla:devel --from-repo=copr:copr.fedorainfracloud.org:rsturla:devel -y rpm --destdir=/tmp
dnf download --enablerepo=copr:copr.fedorainfracloud.org:rsturla:devel --from-repo=copr:copr.fedorainfracloud.org:rsturla:devel -y rpm-libs --destdir=/tmp
dnf download --enablerepo=copr:copr.fedorainfracloud.org:rsturla:devel --from-repo=copr:copr.fedorainfracloud.org:rsturla:devel -y rpm-sign-libs --destdir=/tmp
dnf download --enablerepo=copr:copr.fedorainfracloud.org:rsturla:devel --from-repo=copr:copr.fedorainfracloud.org:rsturla:devel -y rpm-build-libs --destdir=/tmp
dnf download --enablerepo=copr:copr.fedorainfracloud.org:rsturla:devel --from-repo=copr:copr.fedorainfracloud.org:rsturla:devel -y rpm-plugin-audit --destdir=/tmp
dnf download --enablerepo=copr:copr.fedorainfracloud.org:rsturla:devel --from-repo=copr:copr.fedorainfracloud.org:rsturla:devel -y rpm-plugin-selinux --destdir=/tmp
rm -f /tmp/*.src.rpm
rpm -Uvh --force /tmp/rpm-*.rpm

echo

# Determine the actual RPM database location
if [ -d /usr/lib/sysimage/rpm ]; then
  RPM_DB_DIR=/usr/lib/sysimage/rpm
elif [ -d /usr/share/rpm ]; then
  RPM_DB_DIR=/usr/share/rpm
else
  RPM_DB_DIR=/var/lib/rpm
fi

echo "=== RPM database location: $RPM_DB_DIR ==="
echo "=== Before conversion ==="
ls -lah "$RPM_DB_DIR/"

# DON'T delete sqlite yet - we need it for the conversion!
# Just run rebuild which will convert sqlite -> jsonzstd
if ! rpm --rebuilddb 2>&1; then
  echo "=== Handling overlayfs rename limitation ==="

  # Find the rpmrebuilddb temporary directory
  REBUILD_DIR=$(find /usr/lib/sysimage /var/lib /usr/share -maxdepth 1 -name 'rpmrebuilddb.*' -type d 2>/dev/null | head -n1)

  if [ -n "$REBUILD_DIR" ] && [ -d "$REBUILD_DIR" ]; then
    echo "Found rebuild directory: $REBUILD_DIR"
    echo "Replacing $RPM_DB_DIR with rebuilt database..."

    rm -rf "$RPM_DB_DIR"
    cp -a "$REBUILD_DIR" "$RPM_DB_DIR"
    rm -rf "$REBUILD_DIR"

    echo "Database rebuild completed successfully"
  else
    echo "ERROR: Could not find rpmrebuilddb directory"
    exit 1
  fi
fi

# Now clean up old sqlite files after successful conversion
rm -f "$RPM_DB_DIR/rpmdb.sqlite" "$RPM_DB_DIR/rpmdb.sqlite-shm" "$RPM_DB_DIR/rpmdb.sqlite-wal"

# Verify database setup
echo "=== Database Verification ==="
ls -lah "$RPM_DB_DIR/"
if [ -d "$RPM_DB_DIR/jsonzstd" ]; then
  echo "=== JSON-ZSTD Backend (SUCCESS) ==="
  ls -lah "$RPM_DB_DIR/jsonzstd/"
  echo "=== Package count verification ==="
  rpm -qa | wc -l
elif [ -f "$RPM_DB_DIR/rpmdb.sqlite" ]; then
  echo "=== WARNING: Still using sqlite backend ==="
fi

# Clean up COPR repo config
rm -f /etc/yum.repos.d/rsturla-devel.repo
