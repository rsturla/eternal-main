bios:
  systemctl reboot --firmware-setup

[private]
update-flatpak:
  flatpak update -y

[private]
update-system:
  bootc update

[private]
update-firmware:
  fwupdmgr refresh --force
  fwupdmgr get-updates || true
  fwupdmgr update

update:
  @just update-flatpak
  @just update-system
  @just update-firmware

cleanup:
  #!/usr/bin/env bash
  podman system prune -a
  flatpak uninstall --unused
