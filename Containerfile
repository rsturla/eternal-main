ARG FEDORA_VERSION=39
ARG FEDORA_EDITION=base
ARG FEDORA_IMAGE=quay.io/fedora-ostree-desktops/${FEDORA_EDITION}:${FEDORA_VERSION}

# Extract kernel version from CoreOS
FROM quay.io/fedora/fedora-coreos:stable AS coreos-kernel

# e.g. 6.7.7-200.fc39
RUN rpm -qa | grep -oP 'kernel-core-\K[0-9]+\.[0-9]+\.[0-9]+-[0-9]+\.fc[0-9]+' | head -n 1 >> /tmp/kernel-version

FROM ${FEDORA_IMAGE} as base

ARG FEDORA_VERSION
ARG FEDORA_EDITION

COPY files/_base /
COPY files/_${FEDORA_EDITION} /
COPY --from=coreos-kernel /tmp/kernel-version /usr/etc/kernel-version

COPY scripts/ /tmp/scripts

# Replace the kernel version with the one from CoreOS
RUN KERNEL_VERSION=$(cat /usr/etc/kernel-version) && \
  KERNEL_MAJOR_MINOR_PATCH=$(echo $KERNEL_VERSION | cut -d '-' -f 1) && \
  KERNEL_RELEASE=$(echo $KERNEL_VERSION | cut -d '-' -f 2) && \
  rpm-ostree override replace --experimental \
    https://kojipkgs.fedoraproject.org//packages/kernel/$KERNEL_MAJOR_MINOR_PATCH/$KERNEL_RELEASE/x86_64/kernel-$KERNEL_MAJOR_MINOR_PATCH-$KERNEL_RELEASE.x86_64.rpm \
    https://kojipkgs.fedoraproject.org//packages/kernel/$KERNEL_MAJOR_MINOR_PATCH/$KERNEL_RELEASE/x86_64/kernel-core-$KERNEL_MAJOR_MINOR_PATCH-$KERNEL_RELEASE.x86_64.rpm \
    https://kojipkgs.fedoraproject.org//packages/kernel/$KERNEL_MAJOR_MINOR_PATCH/$KERNEL_RELEASE/x86_64/kernel-modules-$KERNEL_MAJOR_MINOR_PATCH-$KERNEL_RELEASE.x86_64.rpm \
    https://kojipkgs.fedoraproject.org//packages/kernel/$KERNEL_MAJOR_MINOR_PATCH/$KERNEL_RELEASE/x86_64/kernel-modules-core-$KERNEL_MAJOR_MINOR_PATCH-$KERNEL_RELEASE.x86_64.rpm \
    https://kojipkgs.fedoraproject.org//packages/kernel/$KERNEL_MAJOR_MINOR_PATCH/$KERNEL_RELEASE/x86_64/kernel-modules-extra-$KERNEL_MAJOR_MINOR_PATCH-$KERNEL_RELEASE.x86_64.rpm \
  && \
  rm -rf /var/* /tmp/* && \
  ostree container commit

RUN chmod +x /tmp/scripts/*.sh /tmp/scripts/_${FEDORA_EDITION}/*.sh && \
  /tmp/scripts/setup.sh --version ${FEDORA_VERSION} --base ${FEDORA_EDITION} && \
  /tmp/scripts/cleanup.sh --version ${FEDORA_VERSION} --base ${FEDORA_EDITION} \
  && \
  rpm-ostree cleanup -m && \
  rm -rf /tmp/* /var/* && \
  ostree container commit
