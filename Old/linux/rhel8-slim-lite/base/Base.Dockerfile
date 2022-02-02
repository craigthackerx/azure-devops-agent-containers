#Use supplier image
FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

LABEL org.opencontainers.image.source=https://github.com/craigthackerx/azure-devops-agent-containers

#Set args with blank values - these will be over-written with the CLI
ARG ACCEPT_EULA=y

#Set the environment with the CLI-passed arguements
ENV ACCEPT_EULA ${ACCEPT_EULA}

#Declare user expectation, I am performing root actions, so use root.
USER root

#Install needed packages as well as setup python with args and pip
RUN mkdir -p /azp && \
    microdnf update -y && microdnf upgrade -y && microdnf install -y sudo && sudo microdnf install -y \
    bash \
    bzip2-devel \
    ca-certificates \
    curl \
    gcc \
    git \
    gnupg \
    gnupg2 \
    jq \
    libffi-devel \
    libicu-devel \
    make \
    openssl-devel \
    sqlite-devel \
    unzip \
    wget \
    zip  \
    zlib-devel && \
    microdnf clean all && microdnf clean all && [ ! -d /var/cache/yum ] || rm -rf /var/cache/yum

#Prepare container for Azure DevOps script execution
WORKDIR /azp
COPY start.sh /azp/start.sh
CMD [ "./start.sh" ]


