#!/usr/bin/env bash

#Use this script to fetch the latest version of Azure DevOps

set -xeou pipefail

USER="microsoft"
REPO="azure-pipelines-agent"
OS="linux"
ARCH="x64"
PACKAGE="tar.gz"

if [ "$(command -v jq)" ] && [ "$(command -v curl)" ] && [ "$(command -v sed)" ]; then
  echo "You have the needed package to run the script"

  else
    echo "You do not have the needed packages to run the script, please install them" && exit 1

fi

azdoLatestAgentVersion="$(curl --silent "https://api.github.com/repos/${USER}/${REPO}/releases/latest" | jq -r .tag_name)" && \

strippedTagAzDoAgentVersion="$(echo "${azdoLatestAgentVersion}" | sed 's/v//')" && \

curl "https://vstsagentpackage.azureedge.net/agent/${strippedTagAzDoAgentVersion}/vsts-agent-${OS}-${ARCH}-${strippedTagAzDoAgentVersion}.${PACKAGE}" -o agent."${PACKAGE}"
