#!/usr/bin/env bash

set -euox pipefail

rpm-ostree install \
  greenboot \
  greenboot-default-health-checks

systemctl enable greenboot-healthcheck.service
