ARG MAJOR_VERSION=43
ARG DESKTOP_ENVIRONMENT=gnome
ARG IMAGE_REGISTRY=quay.io/fedora-ostree-desktops/silverblue
ARG FEDORA_IMAGE=${IMAGE_REGISTRY}:${MAJOR_VERSION}
ARG COREOS_KERNEL="N/A"
ARG AKMODS_TAG=${MAJOR_VERSION}

FROM scratch AS ctx

ARG AKMODS_TAG

COPY ./scripts /scripts
COPY ./files /files

COPY --from=ghcr.io/rsturla/akmods/v4l2loopback:${AKMODS_TAG} / /akmods/v4l2loopback/

FROM ${FEDORA_IMAGE} AS base

ARG DESKTOP_ENVIRONMENT
ARG MAJOR_VERSION
ARG COREOS_KERNEL

COPY --from=ctx files/_base/ /
COPY --from=ctx files/_${DESKTOP_ENVIRONMENT}* /

RUN --mount=type=tmpfs,target=/var \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=bind,from=ctx,src=/,dst=/buildcontext \
    --mount=type=bind,from=ctx,src=/akmods,dst=/buildcontext/akmods \
    bash /buildcontext/scripts/setup.sh --base ${DESKTOP_ENVIRONMENT} && \
    bash /buildcontext/scripts/cleanup.sh --base ${DESKTOP_ENVIRONMENT}

RUN bootc container lint --no-truncate --fatal-warnings
