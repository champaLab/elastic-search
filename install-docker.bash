#!/bin/bash

# This script installs Docker and Docker Compose on Ubuntu

# Update package list and install prerequisites
echo "Updating package list and installing prerequisites..."
sudo apt update -y
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
echo "Adding Docker’s official GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the Docker repository
echo "Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list and install Docker Engine
echo "Installing Docker Engine..."
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Start Docker service and enable it to run at startup
echo "Starting Docker and enabling it to run at startup..."
sudo systemctl start docker
sudo systemctl enable docker

# Verify Docker installation
echo "Verifying Docker installation..."
docker --version
if [ $? -ne 0 ]; then
  echo "Docker installation failed!"
  exit 1
fi
echo "Docker installed successfully."

# Install Docker Compose
echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K[0-9.]+')" /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify Docker Compose installation
echo "Verifying Docker Compose installation..."
docker-compose --version
if [ $? -ne 0 ]; then
  echo "Docker Compose installation failed!"
  exit 1
fi
echo "Docker Compose installed successfully."

# Add the current user to the docker group
echo "Adding $USER to the docker group..."
sudo usermod -aG docker $USER
echo "Please log out and back in for changes to take effect."

echo "Installation completed! Docker and Docker Compose are ready to use."
