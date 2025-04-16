ARG MAJOR_VERSION=42
ARG DESKTOP_ENVIRONMENT=gnome
ARG IMAGE_REGISTRY=quay.io/fedora/fedora-silverblue
ARG FEDORA_IMAGE=${IMAGE_REGISTRY}:${MAJOR_VERSION}
ARG COREOS_KERNEL="N/A"

FROM ${FEDORA_IMAGE} AS base

ARG MAJOR_VERSION
ARG DESKTOP_ENVIRONMENT
ARG COREOS_KERNEL

COPY files/_base files/_${DESKTOP_ENVIRONMENT}* /

# Fetch akmods
COPY --from=ghcr.io/rsturla/akmods/v4l2loopback:${MAJOR_VERSION} /rpms /tmp/akmods/rpms
COPY --from=ghcr.io/rsturla/akmods/v4l2loopback:${MAJOR_VERSION} /scripts /tmp/akmods/scripts/v4l2loopback

COPY scripts/ /tmp/scripts

RUN chmod +x /tmp/scripts/*.sh /tmp/scripts/_${DESKTOP_ENVIRONMENT}/*.sh && \
  /tmp/scripts/setup.sh --base ${DESKTOP_ENVIRONMENT} && \
  /tmp/scripts/cleanup.sh --base ${DESKTOP_ENVIRONMENT}
