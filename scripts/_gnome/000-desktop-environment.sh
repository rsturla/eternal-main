#!/usr/bin/env bash

set -euox pipefail

dnf -y install \
	-x PackageKit \
	-x PackageKit-command-not-found \
	-x gnome-software-fedora-langpacks \
	"NetworkManager-adsl" \
	"centos-backgrounds" \
	"gdm" \
	"gnome-bluetooth" \
	"gnome-color-manager" \
	"gnome-control-center" \
	"gnome-initial-setup" \
	"gnome-remote-desktop" \
	"gnome-session-wayland-session" \
	"gnome-settings-daemon" \
	"gnome-shell" \
	"gnome-software" \
	"gnome-user-docs" \
	"gvfs-fuse" \
	"gvfs-goa" \
	"gvfs-gphoto2" \
	"gvfs-mtp" \
	"gvfs-smb" \
	"libsane-hpaio" \
	"nautilus" \
	"orca" \
	"ptyxis" \
	"sane-backends-drivers-scanners" \
	"xdg-desktop-portal-gnome" \
	"xdg-user-dirs-gtk" \
	"yelp-tools"
