#!/usr/bin/env bash

set -euox pipefail

curl -sL https://codeberg.org/fabiscafe/game-devices-udev/archive/main.zip -o /tmp/game-devices-udev.zip
unzip -q /tmp/game-devices-udev.zip -d /tmp
cp -r /tmp/game-devices-udev/* /usr/lib/udev/rules.d/
mkdir /usr/etc/modules-load.d
echo "uinput" >> /usr/etc/modules-load.d/uinput.conf
