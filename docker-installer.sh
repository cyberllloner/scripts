#!/bin/bash

# Check if script is being run with sudo privileges
if [ $(id -u) -ne 0 ]; then
   echo "This script must be run as root"
   exit 1
fi

set -e

# Update apt
apt update

# Install required packages
apt install -y ca-certificates curl lsb-release

# Create directory for keyring
install -m 0755 -d /etc/apt/keyrings

# Download and configure Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Configure Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update apt and install Docker
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Run without sudo
sudo usermod -aG docker $USER
newgrp docker
