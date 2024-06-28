#!/usr/bin/env bash

set -euox pipefail

# Delete gdm udev rules since they mess with Wayland and X11
rm -f /usr/lib/udev/rules.d/61-gdm.rules
