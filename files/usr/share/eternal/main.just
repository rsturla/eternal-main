[private]
default:
  @just --list

bios:
  systemctl reboot --firmware-setup

[private]
update-flatpak:
  flatpak update -y

[private]
update-system:
  rpm-ostree update

[private]
update-firmware:
  fwupdmgr refresh --force
  fwupdmgr get-updates || true
  fwupdmgr update

update:
  @just update-flatpak
  @just update-system
  @just update-firmware

sign:
  #!/usr/bin/env bash
  echo "Checking current image"

  # Get the current image name and extract the registry
  IMAGE_NAME=$(rpm-ostree status --json | jq -r '.deployments[0]."container-image-reference"')
  REGISTRY="${IMAGE_NAME#ostree-unverified-registry:}"

  # Check if the image is signed or a preview and set to "true" or "false"
  IS_SIGNED=$(echo "$IMAGE_NAME" | grep -q '^ostree-image-signed:' && echo "true" || echo "false")
  IS_PREVIEW=$(echo "$IMAGE_NAME" | grep -q ':pr[0-9-]-[0-9-]' && echo "true" || echo "false")

  # Display image details
  echo "Found Image Details:"
  echo "Image - $IMAGE_NAME"
  echo "Registry - $REGISTRY"
  echo "Signed - $IS_SIGNED"
  echo "Preview - $IS_PREVIEW"

  # If it's neither signed nor a preview, rebase to a signed image
  if [ "$IS_SIGNED" = "false" ] && [ "$IS_PREVIEW" = "false" ]; then
    NEW_IMAGE="ostree-image-signed:registry:$REGISTRY"
    echo "Rebasing to signed image ($NEW_IMAGE)"
    rpm-ostree rebase "$NEW_IMAGE"
  else
    echo "Already on a signed image"
  fi

cleanup:
  #!/usr/bin/env bash
  podman system prune -a
  flatpak uninstall --unused
  rpm-ostree cleanup -bm
  if [ -x "$(command -v nix-store)" ]; then
    nix-store --gc
    nix-store --optimise
  fi
