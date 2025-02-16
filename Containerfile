ARG MAJOR_VERSION=40
ARG DESKTOP_ENVIRONMENT=base
ARG SOURCE_IMAGE=quay.io/fedora/fedora-bootc:${MAJOR_VERSION}
ARG COREOS_KERNEL="N/A"

FROM ${SOURCE_IMAGE} as base

ARG MAJOR_VERSION
ARG DESKTOP_ENVIRONMENT
ARG COREOS_KERNEL

COPY files/_base files/_${DESKTOP_ENVIRONMENT}* /
COPY scripts/ /tmp/scripts

RUN chmod +x /tmp/scripts/*.sh /tmp/scripts/_${DESKTOP_ENVIRONMENT}/*.sh && \
  /tmp/scripts/setup.sh --base ${DESKTOP_ENVIRONMENT} && \
  /tmp/scripts/cleanup.sh --base ${DESKTOP_ENVIRONMENT} \
  && \
  bootc container lint
