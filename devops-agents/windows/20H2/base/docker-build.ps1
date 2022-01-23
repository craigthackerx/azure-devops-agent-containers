#!/usr/bin/env pwsh

Set-PSDebug -Trace 1


$REPO = "ghcr.io"
$USER = "craigthackerx"
$IMAGE_NAME = "azure-devops-agent-base-win20h2:"
$TAGS = "latest"
$DOCKERFILE_NAME = "Base.Dockerfile"

$NORMAL_USER = "ContainerAdministrator"
$PYTHON3_VERSION = "@latest"

  docker build `
    --file=$DOCKERFILE_NAME `
    --tag=$REPO/$USER/$IMAGE_NAME$TAGS `
    --build-arg ACCEPT_EULA=y `
    --build-arg NORMAL_USER=$NORMAL_USER `
    --build-arg PYTHON3_VERSION=$PYTHON3_VERSION `
    .