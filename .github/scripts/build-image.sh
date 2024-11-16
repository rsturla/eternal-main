#!/usr/bin/env bash

set -euo pipefail

# Default values
CONTAINERFILE="./Containerfile"
IMAGE_NAME=""
OS_VERSION=""
OS_EDITION=""
IS_RECHUNK=false
META_OUT_FILE=""

# Function to show usage
usage() {
    echo "Usage: $0 --image-name IMAGE_NAME --os-version OS_VERSION --os-edition OS_EDITION [options]"
    echo
    echo "Options:"
    echo "  --containerfile CONTAINERFILE  Path to the Containerfile (default: './Containerfile')"
    echo "  --image-name IMAGE_NAME        Name of the image (required)"
    echo "  --os-version OS_VERSION        OS version (required)"
    echo "  --os-edition OS_EDITION        OS edition (required)"
    echo "  --is-rechunk true|false        Whether to rechunk the image (default: false)"
    echo "  --meta-out-file META_OUT_FILE  Path to the metadata output file"
    exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --containerfile)
            CONTAINERFILE="$2"
            shift 2
            ;;
        --image-name)
            IMAGE_NAME="$2"
            shift 2
            ;;
        --os-version)
            OS_VERSION="$2"
            shift 2
            ;;
        --os-edition)
            OS_EDITION="$2"
            shift 2
            ;;
        --is-rechunk)
            IS_RECHUNK="$2"
            shift 2
            ;;
        --meta-out-file)
            META_OUT_FILE="$2"
            shift 2
            ;;
        *)
            echo "Unknown argument: $1"
            usage
            ;;
    esac
done

# Check required arguments (image name, os version, os edition)
if [[ -z "$IMAGE_NAME" || -z "$OS_VERSION" || -z "$OS_EDITION" ]]; then
    echo "Error: Missing required arguments"
    usage
fi

# Generate tags based on OS version, edition, and rechunk flag
generate_tags() {
    local os_version="$1"
    local os_edition="$2"
    local is_rechunk="$3"

    local tags=()

    tags+=("$IMAGE_NAME:$os_version-$os_edition")
    tags+=("$IMAGE_NAME:$os_version-$os_edition-$(date +%Y%m%d%H%M%S)")
    tags+=("$IMAGE_NAME:$os_version-$os_edition-$(date +%Y%m%d)")

    # If a GitHub sha is available, add a tag with the ref
    if [[ -n "${GITHUB_SHA:-}" ]]; then
        local ref_tag="${GITHUB_SHA::8}"
        tags+=("$IMAGE_NAME:$os_version-$os_edition-$sha_tag")
        tags+=("$IMAGE_NAME:$os_version-$os_edition-$sha_tag-$(date +%Y%m%d%H%M%S)")
    fi

    echo "${tags[@]}"
}

# Generate image tags
tags=($(generate_tags "$OS_VERSION" "$OS_EDITION" "$IS_RECHUNK"))

# Build the container image with the generated tags
tag_args=$(printf -- "--tag %s " "${tags[@]}")
echo "Building image with tags: ${tags[@]}"
podman build \
    -f "$CONTAINERFILE" \
    $tag_args \
    .

# Output metadata to the specified file
if [[ -n "$META_OUT_FILE" ]]; then
    echo "Writing metadata to $META_OUT_FILE..."
    {
        echo "IMAGE_NAME=$IMAGE_NAME"
        echo "OS_VERSION=$OS_VERSION"
        echo "OS_EDITION=$OS_EDITION"
        echo "IS_RECHUNK=$IS_RECHUNK"
        echo "TAGS=${tags[@]}"
    } > "$META_OUT_FILE"
else
    echo "No metadata output file specified. Skipping metadata output."
fi

echo "Build completed successfully."
