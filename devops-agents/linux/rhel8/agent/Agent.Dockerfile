FROM ghcr.io/craigthackerx/azure-devops-rhel8:latest

ARG AZP_URL=https://dev.azure.com/Example
ARG AZP_TOKEN=ExamplePatToken
ARG AZP_AGENT_NAME=Example
ARG AZP_POOL=PoolName
ARG AZP_WORK=_work

ENV AZP_URL ${AZP_URL}
ENV AZP_TOKEN ${AZP_TOKEN}
ENV AZP_AGENT_NAME ${AZP_AGENT_NAME}
ENV AZP_POOL ${AZP_POOL}
ENV AZP_WORK ${AZP_WORK}

ARG NORMAL_USER=azp

ENV NORMAL_USER ${NORMAL_USER}

RUN useradd -ms /bin/bash ${NORMAL_USER}

USER ${NORMAL_USER}