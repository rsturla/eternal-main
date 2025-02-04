ARG FEDORA_VERSION=41
ARG FEDORA_EDITION=base
ARG IMAGE_REGISTRY=quay.io/fedora/fedora-${FEDORA_EDITION}-atomic
ARG FEDORA_IMAGE=${IMAGE_REGISTRY}:${FEDORA_VERSION}
ARG COREOS_KERNEL="N/A"

FROM ${FEDORA_IMAGE} as base

ARG FEDORA_VERSION
ARG FEDORA_EDITION
ARG COREOS_KERNEL

COPY files/_base /
COPY files/_${FEDORA_EDITION}* /

COPY scripts/ /tmp/scripts

RUN chmod +x /tmp/scripts/*.sh /tmp/scripts/_${FEDORA_EDITION}/*.sh && \
  /tmp/scripts/setup.sh --base ${FEDORA_EDITION} && \
  /tmp/scripts/cleanup.sh --base ${FEDORA_EDITION} \
  && \
  bootc container lint
