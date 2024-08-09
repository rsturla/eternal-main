#!/usr/bin/env bash

set -euox pipefail

git clone https://github.com/pop-os/cosmic-wallpapers.git /tmp/wallpapers
cp /tmp/wallpapers/* /usr/share/backgrounds/
