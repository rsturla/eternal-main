ARG MAJOR_VERSION=42
ARG DESKTOP_ENVIRONMENT=gnome
ARG IMAGE_REGISTRY=quay.io/fedora/fedora-silverblue
ARG FEDORA_IMAGE=${IMAGE_REGISTRY}:${MAJOR_VERSION}
ARG COREOS_KERNEL="N/A"
ARG AKMODS_TAG=${MAJOR_VERSION}

FROM ${FEDORA_IMAGE} AS base

ARG MAJOR_VERSION
ARG DESKTOP_ENVIRONMENT
ARG COREOS_KERNEL
ARG AKMODS_TAG

COPY files/_base files/_${DESKTOP_ENVIRONMENT}* /

# Fetch akmods
COPY --from=ghcr.io/rsturla/akmods/v4l2loopback:${AKMODS_TAG} /rpms /tmp/akmods/rpms
COPY --from=ghcr.io/rsturla/akmods/v4l2loopback:${AKMODS_TAG} /scripts /tmp/akmods/scripts/v4l2loopback

COPY scripts/ /tmp/scripts

RUN chmod +x /tmp/scripts/*.sh /tmp/scripts/_${DESKTOP_ENVIRONMENT}/*.sh && \
  /tmp/scripts/setup.sh --base ${DESKTOP_ENVIRONMENT} && \
  /tmp/scripts/cleanup.sh --base ${DESKTOP_ENVIRONMENT}
