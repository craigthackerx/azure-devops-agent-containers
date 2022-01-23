# Azure DevOps Agent Containers

Hello :wave:

In this repo, you will find the various files needed to host a Self-Hosted Azure DevOps Agent inside of a container as well as examples of a CI/CD workflow.

These images try to follow the [Microsoft documentation on running self-hosted agent in Docker](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops), but try to add some improvements to this workflow (at least for me), and the repos purpose is to give an overall example of a workflow on how you can do this.  Obviously, being containers, we will all have different usability, so please, feel free to take the examples and gut the parts you don't need.

There are several projects which attempt to do this, but never in a way that I "_liked_", so this workflow is to document those short-gaps and try and provide some community support where I can.  I am by no means an expert in this, and this project comes with absolutely no warranty, but should you wish to raise an issue with question, or iterate an improvement where I've missed something, then please, raise a PR and issue thread to discuss :smile:.

The only thing to note, these containers have no "real" inherit dependencies, in theory, passing `ENV` and/or `ARG`'s into your container with the `start.sh` and `start.ps1` scripts that I have based from the Microsoft documentation is enough to get going. But I will try to document what parts are what and why - and my containers are only an example, so check out the Usage section for more info.

My containers probably don't follow best practice as I am not really employing any real shell-scripts or layer optimization, but these work for me. Here is some high level.

## High-level info

- CI/CD with GitHub Actions :rocket: - (Azure DevOps CI/CD coming soon) - Using easy, readable, script params instead of in-built Actions for easy migrations to other CI/CDs
- Container registry using GitHub Packages with Github Container Registry :sunglasses:
- Example scripts in Podman, CI/CD pipelines in Podman for Linux and Docker for Windows :whale:
- Linux Images used in the repo:
   - [RedHat 8 Universal Basic Image](https://catalog.redhat.com/software/container-stacks/detail/5ec53f50ef29fd35586d9a56)
 - Windows Image used in the repo:
   - [Windows Server 2022 LTSC](https://hub.docker.com/_/microsoft-windows-server/) 

# Usage

This repo has 2 main concepts:

- The base image, which forms the overall base of all of your agents - this is a shared layer where updates and dependencies across all of your projects should sit - These agents may end up being used by more than one team, so try to keep the base as static as possible. So for my example, I am installing Python, for you it may be Java, or Go, or .NET or even more, but just remember, the Python is for what I am doing. In my example files, I am installing:

</br>

  - On Linux:
     - Various packages and updates needed.
     - Python - Latest version with argument at pipeline level for roll-back options - This is for Azure-CLI which I wish to be part of ALL of my agents
     - Azure-CLI - Installed via global pip3
     - PowerShell 7 - With all Azure modules downloaded (these are around 2GB in size, which is why its part of the base)
     - The script which will execute on `CMD` in the container, which will fetch the latest Azure Pipelines agent on execution
       - **NOTE: The script is not intended to be ran by the base, but the agent, as it requires various build arguments to execute and connect to Azure DevOps** 

  - On Windows:
    - Chocolatey and Scoop installed
    - Python - Latest version from chocolatey
    - Azure-CLI - Latest version from chocolatey
    - Git - Latest from chocolatey (and will also install Bash)
    - 7-Zip
    - Scoop "extras" bucket
      - **NOTE: The script is not intended to be ran by the base, but the agent, as it requires various build arguments to execute and connect to Azure DevOps**

</br>

  - The agent image, this is where your agent itself is going to have its packages etc implemented.  It may be you want one image for building your React code, and another for your DevOps toolbox, installing things like Terraform, Packer, Ansible etc, but as intended, you will want these to be part of the same base - this is to make distribution and packages.  So essentially, your goal with this image is to purpose build an amount of agents and pass in your instance information.  So to summarize:

</br>

  - This image is intended to be bespoke per project, sometimes you will need many of these to make up a cluster of agents.
  - You are expected to pass your Azure DevOps information at this layer - **Be very wary** of how you store these - Environment files are supported, but be aware, if you host this publicly, someone could potentially connect to your Azure DevOps instance if you aren't careful about how you store your secrets etc
  - Your secrets are passed into the container as either environment variables `ENV` with optional `ARG` commands to make use of a secret manager like Azure Keyvault Secrets or GitHub secrets, you will need to pass your DevOps URL, a PAT token with various permissions (detailed below).
  - You should install your bespoke packages on this layer
  - You should consider container security, for example, running the container as a non-root user and having least privileged where possible, this example uses a `NORMAL_USER` for its `CMD` context when the container starts, so this user must be made and have the `USER` directive set, as well as `PATH` updated.  Always check the upstream base image for vulnerabilities before building agents on top.
  - Users are generated using some form of random entropy with a input argument, to ensure conflict would be close to impossible - if you want to hard-code your agent name, you can do this with an `--build-arg`
  - Consider your labels, these examples use [podman](https://docs.podman.io) and use [podman-auto-update](https://docs.podman.io/en/latest/markdown/podman-auto-update.1.html) to help with CI/CD.  Similar functionality can be done with [containrrr/watchtower](https://github.com/containrrr/watchtower)