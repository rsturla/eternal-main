default:
  @just --unstable --list

bios:
  systemctl reboot --firmware-setup

update-flatpak:
  flatpak update -y

update-system:
  rpm-ostree update

update:
  @just --unstable update-flatpak
  @just --unstable update-system
