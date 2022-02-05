#!/usr/bin/env bash

[ "$(whoami)" = root ] || { sudo "$0" "$@"; exit $?; }


REPO="ghcr.io"
USER="craigthackerx"
IMAGE_NAME="azure-devops-agent-rhel8-podman-agent-"
TAGS="latest"
DOCKERFILE_NAME="Agent.Dockerfile"

AZP_URL="https://dev.azure.com/ExampleOrg/ExampleProj"
AZP_TOKEN="ExamplePATTOKEN"
AZP_POOL="ExamplePOOL"
AZP_WORK="_work"

POD_NAME="azdo-agent-pod"


START="1"
END="3"

for INDEX in $(seq ${START} ${END})
do

  podman build \
    --file="${DOCKERFILE_NAME}" \
    --tag="${REPO}/${USER}/${IMAGE_NAME}${INDEX}:${TAGS}" \
    --build-arg NORMAL_USER="$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c10)"  \
    --build-arg ACCEPT_EULA="y" \
    --build-arg AZP_URL="${AZP_URL}" \
    --build-arg AZP_TOKEN="${AZP_TOKEN}" \
    --build-arg AZP_AGENT_NAME="$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c10)" \
    --build-arg AZP_POOL="${AZP_POOL}" \
    --build-arg AZP_WORK="${AZP_WORK}"
done


podman pod create \
--name "${POD_NAME}" && \

for INDEX in $(seq ${START} ${END})
do

podman run -dt \
--pod ${POD_NAME} \
 --privileged \
"${REPO}/${USER}/${IMAGE_NAME}${INDEX}:${TAGS}"

done