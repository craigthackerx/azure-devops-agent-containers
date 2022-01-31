#Use supplier image
FROM ubuntu:latest

LABEL org.opencontainers.image.source=https://github.com/craigthackerx/azure-devops-agent-containers

#Set args with blank values - these will be over-written with the CLI
ARG ACCEPT_EULA=y

#Set the environment with the CLI-passed arguements
ENV ACCEPT_EULA ${ACCEPT_EULA}
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
    apt-get clean && apt-get autoremove

#Prepare container for Azure DevOps script execution
WORKDIR /azp
COPY start.sh /azp/start.sh
CMD [ "./start.sh" ]
