#Use supplier image
FROM debian:stable-slim

LABEL org.opencontainers.image.source=https://github.com/craigthackerx/azure-devops-agent-containers

#Set args with blank values - these will be over-written with the CLI
ARG ACCEPT_EULA=y
ARG PYTHON3_VERSION=3.10.1

#Set the environment with the CLI-passed arguements
ENV ACCEPT_EULA ${ACCEPT_EULA}
ENV PYTHON3_VERSION ${PYTHON3_VERSION}
ENV DEBIAN_FRONTEND="noninteractive"

#Declare user expectation, I am performing root actions, so use root.
USER root

#Install needed packages as well as setup python with args and pip
RUN mkdir -p /azp && \
    apt-get update -y && apt-get dist-upgrade -y && apt-get install -y \
    apt-transport-https \
    bash \
    libbz2-dev \
    ca-certificates \
    curl \
    gcc \
    gnupg \
    gnupg2 \
    git \
    jq \
    libffi-dev \
    libicu-dev \
    make \
    software-properties-common \
    libsqlite3-dev \
    libssl-dev\
    unzip \
    wget \
    zip  \
    zlib1g-dev && \
              wget https://www.python.org/ftp/python/${PYTHON3_VERSION}/Python-${PYTHON3_VERSION}.tgz && \
              tar xzf Python-${PYTHON3_VERSION}.tgz && rm -rf tar xzf Python-${PYTHON3_VERSION}.tgz && \
              cd Python-${PYTHON3_VERSION} && ./configure --enable-optimizations --enable-loadable-sqlite-extensions && \
              make install && cd .. && rm -rf Python-${PYTHON3_VERSION} && \
              export PATH=$PATH:/usr/local/bin/python3 && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
              python3 get-pip.py && pip3 install virtualenv && \
                pip3 install --upgrade pip && \
                pip3 install azure-cli && \
                pip3 install --upgrade azure-cli && \
wget -q https://packages.microsoft.com/config/debian/$(grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"')/packages-microsoft-prod.deb && \
dpkg -i packages-microsoft-prod.deb && \
apt-get update && \
apt-get install -y powershell

#Prepare container for Azure DevOps script execution
WORKDIR /azp
COPY start.sh /azp/start.sh
CMD [ "./start.sh" ]

#Install Azure Modules for Powershell - This can take a while, so setting as final step to shorten potential rebuilds
RUN pwsh -Command Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted ; pwsh -Command Install-Module -Name Az -Force -AllowClobber -Scope AllUsers -Repository PSGallery && \
    apt-get clean && apt-get autoremove

