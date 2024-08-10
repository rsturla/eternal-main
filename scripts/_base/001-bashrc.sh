#!/usr/bin/env bash

set -euox pipefail

cat <<'EOF' >> /etc/bashrc
for file in /etc/bashrc.d/*.sh; do
  source "$file"
done
EOF

mkdir -p /etc/bashrc.d
