#!/usr/bin/env bash

set -euox pipefail

cp /etc/bashrc /usr/etc/bashrc
cat <<'EOF' >> /usr/etc/bashrc
for file in /etc/bashrc.d/*.sh; do
  source "$file"
done
EOF

mkdir -p /usr/etc/bashrc.d
