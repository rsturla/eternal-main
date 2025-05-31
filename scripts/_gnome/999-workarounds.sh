#!/usr/bin/env bash

set -euox pipefail

# Workaround mutter regression, remove in early June
# https://bugzilla.redhat.com/show_bug.cgi?id=2369147

dnf -y swap mutter mutter-0:48.1-1.fc42
dnf versionlock add mutter
