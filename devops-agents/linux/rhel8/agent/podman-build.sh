#!/usr/bin/env bash

DOCKER_REPO="docker.io"
GITHUB_REPO="ghcr.io"

USER="craigthackerx"
IMAGE_NAME="azure-devops-agent-rhel8"
TAGS="latest"
DOCKERFILE_NAME="Base.Dockerfile"

AZP_URL="https://dev.azure.com/ExampleOrg/ExampleProj"
AZP_TOKEN="ExamplePATTOKEN"
AZP_POOL="ExamplePOOL"
AZP_WORK="_work"

DOCKER_IMAGE="${DOCKER_REPO}/${USER}/${IMAGE_NAME}:${TAGS}"
GITHUB_IMAGE="${GITHUB_REPO}/${USER}/${IMAGE_NAME}:${TAGS}"

set -xeou pipefail

  podman build \
    --file="${DOCKERFILE_NAME}" \
    --tag="DOCKER_IMAGE" \
    --build-arg NORMAL_USER="$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c10)"  \
    --build-arg ACCEPT_EULA="y" \
    --build-arg AZP_URL="${AZP_URL}" \
    --build-arg AZP_TOKEN="${AZP_TOKEN}" \
    --build-arg AZP_AGENT_NAME="$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c10)" \
    --build-arg AZP_POOL="${AZP_POOL}" \
    --build-arg AZP_WORK="${AZP_WORK}"

  podman tag "${DOCKER_IMAGE}" \
  "${GITHUB_IMAGE}"
