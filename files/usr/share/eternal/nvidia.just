nvidia-setup:
  @echo "Configuring NVIDIA drivers..."
  @just --unstable nvidia-disable-nouveau
  @just --unstable nvidia-secure-boot-enable
  @just --unstable nvidia-firefox-vaapi
  @echo "Configuring NVIDIA drivers... done"

nvidia-disable-nouveau:
  rpm-ostree kargs \
    --append-if-missing=rd.driver.blacklist=nouveau \
    --append-if-missing=modprobe.blacklist=nouveau \
    --append-if-missing=nvidia-drm.modeset=1

nvidia-secure-boot-enable:
  sudo mokutil --import /etc/pki/akmods/certs/eternal-akmods.der

test-cuda:
  podman run \
    --user 1000:1000 \
    --security-opt=no-new-privileges \
    --cap-drop=ALL \
    --security-opt label=type:nvidia_container_t  \
    docker.io/mirrorgooglecontainers/cuda-vector-add:v0.1

nvidia-firefox-vaapi:
  flatpak override \
    --user \
    --filesystem=host-os \
    --env=LIBVA_DRIVER_NAME=nvidia \
    --env=LIBVA_DRIVERS_PATH=/run/host/usr/lib64/dri \
    --env=LIBVA_MESSAGING_LEVEL=1 \
    --env=MOZ_DISABLE_RDD_SANDBOX=1 \
    --env=NVD_BACKEND=direct \
    --env=MOZ_ENABLE_WAYLAND=1 \
    org.mozilla.firefox
