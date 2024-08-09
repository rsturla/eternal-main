#!/usr/bin/env bash

set -euox pipefail

git clone https://github.com/pop-os/cosmic-wallpapers.git /tmp/wallpapers
# For each wallpaper in the /tmp/wallpapers/original directory, we need to fetch the wallpaper from
# https://media.githubusercontent.com/media/pop-os/cosmic-wallpapers/master/original/<wallpaper> and save it to the
# /usr/share/backgrounds/cosmic directory.

# Create the directory if it doesn't exist
mkdir -p /usr/share/backgrounds/cosmic

# Copy the wallpapers
for wallpaper in /tmp/wallpapers/original/*; do
    wallpaper_name=$(basename $wallpaper)
    curl -L https://media.githubusercontent.com/media/pop-os/cosmic-wallpapers/master/original/$wallpaper_name -o /usr/share/backgrounds/cosmic/$wallpaper_name
done

# Clean up
rm -rf /tmp/wallpapers
