#!/usr/bin/env bash

set -euox pipefail

systemctl disable rpm-ostreed-automatic.timer
systemctl enable bootc-fetch-apply-updates.timer

cat > /usr/lib/systemd/system/bootc-fetch-apply-updates.service.d/10-no-apply.conf <<'EOF'
[Service]
ExecStart=
ExecStart=/usr/bin/bootc upgrade --quiet
EOF
