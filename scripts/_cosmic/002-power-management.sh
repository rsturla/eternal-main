#!/usr/bin/env bash

set -euox pipefail

# Install the required packages
rpm-ostree install \
    power-profiles-daemon

systemctl enable power-profiles-daemon
