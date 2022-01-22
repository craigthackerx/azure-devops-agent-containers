FROM registry.access.redhat.com/ubi8/ubi:latest

ARG ACCEPT_EULA=y
ARG PYTHON3_VERSION=3.9.10

ENV ACCEPT_EULA ${ACCEPT_EULA}
ENV PYTHON3_VERSION ${PYTHON3_VERSION}

USER root

RUN mkdir -p /azp && \
    yum update -y && yum upgrade -y && yum install -y yum-utils dnf sudo && sudo yum install -y \
    bash \
    bzip2-devel \
    ca-certificates \
    curl \
    gcc \
    gnupg \
    gnupg2 \
    git \
    jq \
    libffi-devel \
    make \
    sqlite-devel \
    openssl-devel \
    unzip \
    wget \
    zip  \
    zlib-devel && \
              wget https://www.python.org/ftp/python/${PYTHON3_VERSION}/Python-${PYTHON3_VERSION}.tgz && \
              tar xzf Python-${PYTHON3_VERSION}.tgz && rm -rf tar xzf Python-${PYTHON3_VERSION}.tgz && \
              cd Python-${PYTHON3_VERSION} && ./configure --enable-optimizations --enable-loadable-sqlite-extensions && \
              make install && cd .. && rm -rf Python-${PYTHON3_VERSION} && \
              export PATH=$PATH:/usr/local/bin/python3 && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
              python3 get-pip.py && pip3 install virtualenv && \
                pip3 install --upgrade pip && \
                pip3 install azure-cli && \
                pip3 install --upgrade azure-cli && \
curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo && \
yum install -y powershell

WORKDIR /azp
COPY start.sh /azp/start.sh
CMD [ "./start.sh" ]

#Install Azure Modules for Powershell - This can take a while
RUN pwsh -Command Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted ; pwsh -Command Install-Module -Name Az -Force -AllowClobber -Scope AllUsers -Repository PSGallery && \
    yum clean all && microdnf clean all && [ ! -d /var/cache/yum ] || rm -rf /var/cache/yum

