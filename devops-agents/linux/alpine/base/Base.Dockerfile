#Use supplier image
FROM alpine:latest

LABEL org.opencontainers.image.source https://github.com/craigthackerx/azure-devops-agent-containers

#Set args with blank values - these will be over-written with the CLI
ARG ACCEPT_EULA=y
ARG PYTHON3_VERSION=3.9.10

#Set the environment with the CLI-passed arguements
ENV ACCEPT_EULA ${ACCEPT_EULA}
ENV PYTHON3_VERSION ${PYTHON3_VERSION}

#Declare user expectation, I am performing root actions, so use root.
USER root

#Install needed packages as well as setup python with args and pip
RUN mkdir -p /azp && \
    apk add --no-cache \
    bash \
    bzip2 \
    bluez-dev \
    bzip2-dev \
    coreutils \
    ca-certificates \
    curl \
    dpkg-dev \
    dpkg \
    expat-dev \
    findutils \
    gcc \
    gdbm-dev \
    gdm-dev \
    gnupg \
    git \
    g++ \
    icu-libs \
    jq \
    less \
    libc-dev \
    libffi \
    libffi-dev \
    libgcc \
    libintl \
    libnsl-dev \
    libssl1.1 \
    libressl-dev \
    libstdc++ \
    libtirpc-dev \
    linux-headers \
    make \
    ncurses-terminfo-base \
    ncurses-dev \
    nss \
    openssl-dev \
    pax-utils \
    readline-dev \
    sqlite-dev \
    tar \
    tcl-dev \
    tk \
    tk-dev \
    util-linux-dev \
    sudo \
    tzdata \
    openssl \
    unzip \
    userspace-rcu \
    wget \
    xz-dev \
    zip  \
    zlib-dev && \
              wget https://www.python.org/ftp/python/${PYTHON3_VERSION}/Python-${PYTHON3_VERSION}.tgz && \
              tar xzf Python-${PYTHON3_VERSION}.tgz && rm -rf tar xzf Python-${PYTHON3_VERSION}.tgz && \
              cd Python-${PYTHON3_VERSION} && ./configure --enable-optimizations --enable-loadable-sqlite-extensions && \
              make install && cd .. && rm -rf Python-${PYTHON3_VERSION} && \
              export PATH=$PATH:/usr/local/bin/python3 && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
              python3 get-pip.py && pip3 install virtualenv && \
                pip3 install --upgrade pip && \
                pip3 install azure-cli && \
                pip3 install --upgrade azure-cli && \
apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache lttng-ust && \
curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.2.1/powershell-7.2.1-linux-alpine-x64.tar.gz -o /tmp/powershell.tar.gz && \
mkdir -p /opt/microsoft/powershell/7 && \
tar xzf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7 && \
chmod +x /opt/microsoft/powershell/7/pwsh && \
ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh

#Prepare container for Azure DevOps script execution
WORKDIR /azp
COPY start.sh /azp/start.sh
CMD [ "./start.sh" ]

#Install Azure Modules for Powershell - This can take a while, so setting as final step to shorten potential rebuilds
RUN pwsh -Command Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted ; pwsh -Command Install-Module -Name Az -Force -AllowClobber -Scope AllUsers -Repository PSGallery && \
    apk cache clean

