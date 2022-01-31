#!/usr/bin/env bash

DOCKER_REPO="docker.io"
GITHUB_REPO="ghcr.io"

USER="craigthackerx"
IMAGE_NAME="azure-devops-agent-base-alpine"
TAGS="latest"
DOCKERFILE_NAME="Base.Dockerfile"
PYTHON3_VERSION="3.10.1"

DOCKER_IMAGE="${DOCKER_REPO}/${USER}/${IMAGE_NAME}:${TAGS}"
GITHUB_IMAGE="${GITHUB_REPO}/${USER}/${IMAGE_NAME}:${TAGS}"

set -xe

  podman build \
    --file="${DOCKERFILE_NAME}" \
    --tag="${DOCKER_IMAGE}" \
    --build-arg ACCEPT_EULA="y" \
    --build-arg PYTHON3_VERSION="${PYTHON3_VERSION}" \
    --squash
