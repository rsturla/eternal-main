#!/usr/bin/env bash

set -euox pipefail

rpm-ostree install \
  greenboot \
  greenboot-default-health-checks

# Remove healthchecks broken on atomic desktops
rm -rf \
  /usr/lib/greenboot/check/wanted.d/01_update_platforms_check.sh

systemctl enable greenboot-healthcheck.service
