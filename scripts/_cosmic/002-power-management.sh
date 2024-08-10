#!/usr/bin/env bash

set -euox pipefail

# Install the required packages
rpm-ostree install \
    tuned \
    tuned-ppd \
    tuned-utils \
    tuned-utils-systemtap \
    tuned-profiles-atomic

systemctl enable tuned.service
