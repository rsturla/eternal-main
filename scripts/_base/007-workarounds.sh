#!/usr/bin/env bash

set -euox pipefail

systemctl enable suspend-btkill.service

# mitigate upstream packaging bug: https://bugzilla.redhat.com/show_bug.cgi?id=2332429
# swap the incorrectly installed OpenCL-ICD-Loader for ocl-icd, the expected package
dnf swap -y --allowerasing OpenCL-ICD-Loader ocl-icd
