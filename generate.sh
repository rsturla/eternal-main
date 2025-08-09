#!/usr/bin/env bash
set -euo pipefail

# Accept desktop environment as argument, default to 'gnome' if not provided
DESKTOP_ENVIRONMENT="${1:-gnome}"
MAJOR_VERSION=42
IMAGE_REGISTRY="quay.io/fedora/fedora-silverblue"
FEDORA_IMAGE="${IMAGE_REGISTRY}:${MAJOR_VERSION}"
AKMODS_TAG="${MAJOR_VERSION}"
COREOS_KERNEL="N/A"

OUTPUT="Containerfile.gen"

echo "Generating $OUTPUT for desktop environment: $DESKTOP_ENVIRONMENT"

# Start fresh
cat > "$OUTPUT" <<EOF
# syntax=docker/dockerfile:1.4
ARG MAJOR_VERSION=${MAJOR_VERSION}
ARG DESKTOP_ENVIRONMENT=${DESKTOP_ENVIRONMENT}
ARG IMAGE_REGISTRY=${IMAGE_REGISTRY}
ARG FEDORA_IMAGE=\${IMAGE_REGISTRY}:\${MAJOR_VERSION}
ARG AKMODS_TAG=${AKMODS_TAG}
ARG COREOS_KERNEL=${COREOS_KERNEL}

FROM scratch AS ctx

ARG AKMODS_TAG

COPY ./scripts /scripts
COPY ./files /files

COPY --from=ghcr.io/rsturla/akmods/v4l2loopback:\${AKMODS_TAG} /rpms /akmods/v4l2loopback/rpms
COPY --from=ghcr.io/rsturla/akmods/v4l2loopback:\${AKMODS_TAG} /scripts /akmods/v4l2loopback/scripts

FROM \${FEDORA_IMAGE} AS base

ARG DESKTOP_ENVIRONMENT
ARG MAJOR_VERSION
ARG COREOS_KERNEL

COPY --from=ctx files/_base/ /
COPY --from=ctx files/_${DESKTOP_ENVIRONMENT}* /

EOF

# Add base scripts
for script in scripts/_base/*.sh; do
  filename=$(basename "$script")
  echo "RUN --mount=type=cache,target=/var/cache \\" >> "$OUTPUT"
  echo "    --mount=type=cache,target=/var/lib \\" >> "$OUTPUT"
  echo "    --mount=type=cache,target=/var/log \\" >> "$OUTPUT"
  echo "    --mount=type=tmpfs,target=/var/tmp \\" >> "$OUTPUT"
  echo "    --mount=type=tmpfs,target=/tmp \\" >> "$OUTPUT"
  echo "    --mount=type=bind,from=ctx,src=/,dst=/buildcontext \\" >> "$OUTPUT"
  echo "    --mount=type=bind,from=ctx,src=/akmods,dst=/buildcontext/akmods \\" >> "$OUTPUT"
  echo "    /bin/bash /buildcontext/scripts/_base/${filename}" >> "$OUTPUT"
  echo "" >> "$OUTPUT"
done

# Add desktop environment scripts, if not base
if [[ "$DESKTOP_ENVIRONMENT" != "base" ]]; then
  for script in scripts/_${DESKTOP_ENVIRONMENT}/*.sh; do
    filename=$(basename "$script")
    echo "RUN --mount=type=cache,target=/var/cache \\" >> "$OUTPUT"
    echo "    --mount=type=cache,target=/var/lib \\" >> "$OUTPUT"
    echo "    --mount=type=cache,target=/var/log \\" >> "$OUTPUT"
    echo "    --mount=type=tmpfs,target=/var/tmp \\" >> "$OUTPUT"
    echo "    --mount=type=tmpfs,target=/tmp \\" >> "$OUTPUT"
    echo "    --mount=type=bind,from=ctx,src=/,dst=/buildcontext \\" >> "$OUTPUT"
    echo "    /bin/bash /buildcontext/scripts/_${DESKTOP_ENVIRONMENT}/${filename}" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
  done
fi

# Add cleanup script
echo "RUN --mount=type=cache,target=/var/cache \\" >> "$OUTPUT"
echo "    --mount=type=cache,target=/var/lib \\" >> "$OUTPUT"
echo "    --mount=type=cache,target=/var/log \\" >> "$OUTPUT"
echo "    --mount=type=tmpfs,target=/var/tmp \\" >> "$OUTPUT"
echo "    --mount=type=tmpfs,target=/tmp \\" >> "$OUTPUT"
echo "    --mount=type=bind,from=ctx,src=/,dst=/buildcontext \\" >> "$OUTPUT"
echo "    /bin/bash /buildcontext/scripts/cleanup.sh --base ${DESKTOP_ENVIRONMENT}" >> "$OUTPUT"

echo ""
echo "✅ $OUTPUT generated."
