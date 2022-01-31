#Use base image
FROM ghcr.io/craigthackerx/azure-devops-agent-base-rhel8:latest

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
ENV AZP_WORK ${AZP_WORK}
ENV NORMAL_USER ${NORMAL_USER}

#Install tooling with root
RUN terraformLatestVersion=$(curl -sL https://releases.hashicorp.com/terraform/index.json | jq -r '.versions[].builds[].url' | egrep -v 'rc|beta|alpha' | egrep 'linux.*amd64'  | tail -1) && \
    wget "${terraformLatestVersion}" && \
    unzip terraform* && rm -rf terraform*.zip && \
    mv terraform /usr/local/bin && \
    packerLatestVersion=$(curl -sL https://releases.hashicorp.com/packer/index.json | jq -r '.versions[].builds[].url' | egrep -v 'rc|beta|alpha' | egrep 'linux.*amd64'  | tail -1) && \
    wget "${packerLatestVersion}" && \
    unzip packer* && rm -rf packer*.zip && \
    mv packer /usr/local/bin && \
    yum clean all && microdnf clean all && [ ! -d /var/cache/yum ] || rm -rf /var/cache/yum

#Make unpriviledged user
RUN useradd -ms /bin/bash ${NORMAL_USER} && \
    chown -R ${NORMAL_USER} /azp && \
    chmod +x start.sh

#Set as unpriviledged user for default container execution
USER ${NORMAL_USER}

#Set User Path with expected paths for new packages
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/${NORMAL_USER}/.local/bin:${PATH}"

#Install User Packages
RUN pip3 install --user \
    checkov \
    pipenv \
    terraform-compliance \
    virtualenv