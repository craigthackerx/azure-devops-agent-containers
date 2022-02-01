#Use base image
FROM ghcr.io/craigthackerx/azure-devops-agent-base-oracle8-slim-lite:latest

#Set args with blank values - these will be over-written with the CLI
ARG AZP_URL=https://dev.azure.com/Example
ARG AZP_TOKEN=ExamplePatToken
ARG AZP_AGENT_NAME=Example
ARG AZP_POOL=PoolName
ARG AZP_WORK=_work
ARG NORMAL_USER=azp

#Set the environment with the CLI-passed arguements
ENV AZP_URL ${AZP_URL}
ENV AZP_TOKEN ${AZP_TOKEN}
ENV AZP_AGENT_NAME ${AZP_AGENT_NAME}
ENV AZP_POOL ${AZP_POOL}
ENV AZP_WORK ${AZP_WORK}0
ENV NORMAL_USER ${NORMAL_USER}

#Make unpriviledged user
RUN useradd -ms /bin/bash ${NORMAL_USER} && \
    chown -R ${NORMAL_USER} /azp && \
    chmod +x start.sh

#Set as unpriviledged user for default container execution
USER ${NORMAL_USER}

#Set User Path with expected paths for new packages
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/${NORMAL_USER}/.local/bin:${PATH}"
