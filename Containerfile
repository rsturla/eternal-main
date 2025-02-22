ARG MAJOR_VERSION=41
ARG DESKTOP_ENVIRONMENT=base
ARG IMAGE_REGISTRY=quay.io/fedora/fedora-${DESKTOP_ENVIRONMENT}-atomic
ARG FEDORA_IMAGE=${IMAGE_REGISTRY}:${MAJOR_VERSION}
ARG COREOS_KERNEL="N/A"

FROM ${FEDORA_IMAGE} as base

ARG MAJOR_VERSION
ARG DESKTOP_ENVIRONMENT
ARG COREOS_KERNEL

COPY files/_base /
COPY files/_${DESKTOP_ENVIRONMENT}* /

COPY scripts/ /tmp/scripts

RUN chmod +x /tmp/scripts/*.sh /tmp/scripts/_${DESKTOP_ENVIRONMENT}/*.sh && \
  /tmp/scripts/setup.sh --base ${DESKTOP_ENVIRONMENT} && \
  /tmp/scripts/cleanup.sh --base ${DESKTOP_ENVIRONMENT}
