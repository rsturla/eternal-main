ARG FEDORA_VERSION=40
ARG FEDORA_EDITION=base
ARG FEDORA_IMAGE=quay.io/fedora-ostree-desktops/${FEDORA_EDITION}:${FEDORA_VERSION}
ARG COREOS_KERNEL=""

FROM ${FEDORA_IMAGE} as base

ARG FEDORA_VERSION
ARG FEDORA_EDITION
ARG COREOS_KERNEL

COPY files/_base /
COPY files/_${FEDORA_EDITION} /
COPY --from=coreos-kernel /tmp/kernel-version /tmp/kernel-version

COPY scripts/ /tmp/scripts

RUN chmod +x /tmp/scripts/*.sh /tmp/scripts/_${FEDORA_EDITION}/*.sh && \
  /tmp/scripts/setup.sh --version ${FEDORA_VERSION} --base ${FEDORA_EDITION} && \
  /tmp/scripts/cleanup.sh --version ${FEDORA_VERSION} --base ${FEDORA_EDITION} \
  && \
  rpm-ostree cleanup -m && \
  rm -rf /tmp/* /var/* && \
  ostree container commit
