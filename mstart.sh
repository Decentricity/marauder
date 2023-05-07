#!/bin/bash

# Update package list
sudo apt-get update

# Install git
sudo apt-get install -y git

# Install dependencies
sudo apt-get install -y ca-certificates curl gnupg

# Set up Docker keyring directory
sudo install -m 0755 -d /etc/apt/keyrings

# Import Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set permissions for Docker GPG key
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list
sudo apt-get update

# Install Docker components
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose

# Start Docker service
sudo systemctl start docker

# Test Docker installation
sudo docker run hello-world

# Clone Myriad repository
echo "Cloning Myriad repository..."
if [ -d "myriad-api" ]; then
  sudo rm -rf myriad-api
fi
sudo git clone https://github.com/myriadsocial/myriad-api.git
cd myriad-api

echo "Downloading marauder.sh."
sudo curl -o marauder.sh https://raw.githubusercontent.com/Decentricity/marauder/main/marauder.sh

# Make the myriadrun.sh script executable
sudo chmod +x marauder.sh

echo "Downloading the uninstaller."
# Download uninst script
sudo curl -o myriaduninstall.sh https://raw.githubusercontent.com/Decentricity/marauder/main/myriaduninstall.sh

# Make the myriadrun.sh script executable
sudo chmod +x myriaduninstall.sh

echo "Initialization complete. Please run ~/myriad-api/marauder.sh to proceed with the installation and configuration of Myriad."
# Instructions for the user
echo "However, please make sure you have the following information first:"
echo ""
echo "API_VERSION: Set to 'latest' or choose a version from https://github.com/myriadsocial/myriad-api/releases without 'v'"
echo "DOMAIN: The domain you are using for your instance"
echo ""
echo "Wallet"
echo "MYRIAD_ADMIN_SUBSTRATE_MNEMONIC: 12/24 random words generated when creating a new wallet in any provider"
echo "MYRIAD_ADMIN_NEAR_MNEMONIC: 12/24 random words generated when creating a new wallet in any provider"
echo ""
echo "JWT"
echo "JWT_TOKEN_SECRET_KEY: Write a 16 characters random string key (use https://www.random.org/strings/)"
echo "JWT_REFRESH_TOKEN_SECRET_KEY: Write a 16 characters random string key (use https://www.random.org/strings/)"
echo ""
echo "MONGO"
echo "MONGO_USER: your user name"
echo "MONGO_PASSWORD: your password"
echo ""
echo "REDIS"
echo "REDIS_PASSWORD: your password"
echo ""
echo "SMTP"
echo "SMTP_SERVER: smtp.gmail.com"
echo "SMTP_PORT: 465"
echo "SMTP_USERNAME: Your Gmail address"
echo "SMTP_PASSWORD: Your Gmail password"
echo ""
echo "Once you have all of the required data, come back to the install directory (by default ~/myriad-api/) and run the following command:"
echo "  ./marauder.sh"
