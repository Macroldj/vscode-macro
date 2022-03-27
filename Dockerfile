# Start from the code-server Debian base image
FROM codercom/code-server:4.0.2

USER root

COPY settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Install unzip + rclone (support for remote filesystem)
RUN sed -i 's/http\:\/\/deb.debian.org/https\:\/\/mirrors.aliyun.com/g' /etc/apt/sources.list \
 && sed -i 's/http\:\/\/security.debian.org/https\:\/\/mirrors.aliyun.com/g' /etc/apt/sources.list \
 && apt-get update \
 && apt-get install -y curl gcc vim libpq-dev unzip

RUN curl https://rclone.org/install.sh | sudo bash

# Copy rclone tasks to /tmp, to potentially be used
COPY rclone-tasks.json /tmp/rclone-tasks.json

# Fix permissions for code-server
# You can add custom software and dependencies for your environment below
# -----------

# Install a VS Code extension:
# Note: we use a different marketplace than VS Code. See https://github.com/cdr/code-server/blob/main/docs/FAQ.md#differences-compared-to-vs-code
# RUN code-server --install-extension esbenp.prettier-vscode

# Install apt packages:
# RUN sudo apt-get install -y ubuntu-make

# Copy files:
# COPY deploy-container/myTool /home/coder/myTool

# -----------

# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY entrypoint.sh entrypoint.sh
ENTRYPOINT ["bash","entrypoint.sh"]
