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

