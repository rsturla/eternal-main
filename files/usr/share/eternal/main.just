default:
  @just --unstable --list

bios:
  systemctl reboot --firmware-setup

flatpak-update:
  flatpak update -y

system-update:
  rpm-ostree update

update:
  @just flatpak-update
  @just system-update
