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
COPY --from=ghcr.io/rsturla/akmods/v4l2loopback:${AKMODS_TAG} /rpms /buildcontext/akmods/v4l2loopback/rpms
COPY --from=ghcr.io/rsturla/akmods/v4l2loopback:${AKMODS_TAG} /scripts /buildcontext/akmods/v4l2loopback/scripts

COPY scripts/ /buildcontext/scripts

RUN chmod +x /buildcontext/scripts/*.sh /buildcontext/scripts/_${DESKTOP_ENVIRONMENT}/*.sh && \
  /buildcontext/scripts/setup.sh --base ${DESKTOP_ENVIRONMENT} && \
  /buildcontext/scripts/cleanup.sh --base ${DESKTOP_ENVIRONMENT}
