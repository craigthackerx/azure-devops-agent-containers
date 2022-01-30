FROM mcr.microsoft.com/windows/server:ltsc2022-amd64

# escape = `

LABEL org.opencontainers.image.source https://github.com/craigthackerx/azure-devops-agent-containers

ARG NORMAL_USER=ContainerAdministrator
ARG PYTHON3_VERSION=@latest
ARG ACCEPT_EULA=y

ENV NORMAL_USER ${NORMAL_USER}
ENV PYTHON3_VERSION ${PYTHON3_VERSION}
ENV ACCEPT_EULA ${ACCEPT_EULA}

#Use Powershell instead of CMD
SHELL ["powershell", "-Command"]

#Set Unrestricted Policy & Install chocolatey
RUN Set-ExecutionPolicy Unrestricted ;  \
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) ; \
    Set-ExecutionPolicy Bypass -Scope Process -Force; iwr -useb get.scoop.sh | iex ; \
    choco install -y \
    powershell-core ; \
    scoop install \
    7zip \
    git ; \
    scoop bucket add extras ; \
    scoop install \
    curl \
    dark \
    lessmsi \
    jq \
    python${PYTHON3_VERSION} \
    sed \
    which \
    zip ; \
    python -m pip install --upgrade pip ; \
    pip3 install azure-cli

ENV PATH "C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Windows\System32\OpenSSH\;C:\Users\ContainerAdministrator\AppData\Local\Microsoft\WindowsApps;;C:\ProgramData\chocolatey\bin;C:\Users"\\${NORMAL_USER}"\scoop\shims;C:\Program Files\PowerShell\7;C:\Users"\\${NORMAL_USER}"\scoop\apps\python\current\Scripts\;"

#Use Powershell Core instead of 5
SHELL ["pwsh", "-Command"]

RUN mkdir C:/azp
WORKDIR C:/azp
COPY start.ps1 /azp/start.ps1

#This can take a while, which is why its a seperate step
RUN pwsh -Command Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted ; pwsh -Command Install-Module -Name Az -Force -AllowClobber -Scope AllUsers -Repository PSGallery

CMD C:/azp/start.ps1