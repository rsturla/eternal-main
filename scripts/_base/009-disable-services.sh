#!/usr/bin/env bash

set -euox pipefail

systemctl disable pmie.service
systemctl disable pmlogger.service
systemctl disable pmcd.service
