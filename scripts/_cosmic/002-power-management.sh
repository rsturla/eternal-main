#!/usr/bin/env bash

set -euox pipefail

# Install the required packages
dnf install -y power-profiles-daemon

systemctl enable power-profiles-daemon
