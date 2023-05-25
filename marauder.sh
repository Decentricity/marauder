#!/bin/bash
cd ~/myriad-api

echo "Welcome to the Myriad.Social installation process!"
echo "Myriad.Social is a decentralized social network that puts you in control of your data."
echo "This script will guide you through the interactive process of setting up your instance."

# Interactive part of the script
echo "Please enter the required information when prompted."
echo "This is where you decide your usernames and passwords for MONGO and REDIS (you do not need to set them up beforehand). "

echo "The usernames and passwords you set-up in this file will be used by this script to install your Myriad Instance. Make sure you save them in a secure place."
read -p "Enter API version (use 'latest' or a version from https://github.com/myriadsocial/myriad-api/releases without 'v'): " API_VERSION
read -p "Enter your domain: " DOMAIN
read -p "Enter your 12/24 word Substrate wallet mnemonic: " MYRIAD_ADMIN_SUBSTRATE_MNEMONIC
read -p "Enter your 12/24 word NEAR wallet mnemonic: " MYRIAD_ADMIN_NEAR_MNEMONIC
read -p "Enter a 16 characters random JWT token secret key (use https://www.random.org/strings/): " JWT_TOKEN_SECRET_KEY
read -p "Enter a 16 characters random JWT refresh token secret key (use https://www.random.org/strings/): " JWT_REFRESH_TOKEN_SECRET_KEY
read -p "Enter a MongoDB username: " MONGO_USER
read -p "Enter a MongoDB password: " MONGO_PASSWORD
read -p "Enter a Redis password: " REDIS_PASSWORD
read -p "Enter your SMTP server (e.g., smtp.gmail.com): " SMTP_SERVER
read -p "Enter your SMTP port (e.g., 465): " SMTP_PORT
read -p "Enter your Gmail address: " SMTP_USERNAME
read -p "Enter your Gmail password: " SMTP_PASSWORD

# Updating the .env file
sudo cp ./.maintain/deployment/.env-template ./.env
sudo sed -i "s|API_VERSION=.*|API_VERSION=${API_VERSION}|" ./.env
sudo sed -i "s|DOMAIN=.*|DOMAIN=${DOMAIN}|" ./.env
sudo sed -i "s|MYRIAD_ADMIN_SUBSTRATE_MNEMONIC=.*|MYRIAD_ADMIN_SUBSTRATE_MNEMONIC=${MYRIAD_ADMIN_SUBSTRATE_MNEMONIC}|" ./.env
sudo sed -i "s|MYRIAD_ADMIN_NEAR_MNEMONIC=.*|MYRIAD_ADMIN_NEAR_MNEMONIC=${MYRIAD_ADMIN_NEAR_MNEMONIC}|" ./.env
sudo sed -i "s|JWT_TOKEN_SECRET_KEY=.*|JWT_TOKEN_SECRET_KEY=${JWT_TOKEN_SECRET_KEY}|" ./.env
sudo sed -i "s|JWT_REFRESH_TOKEN_SECRET_KEY=.*|JWT_REFRESH_TOKEN_SECRET_KEY=${JWT_REFRESH_TOKEN_SECRET_KEY}|" ./.env
sudo sed -i "s|MONGO_USER=.*|MONGO_USER=${MONGO_USER}|" ./.env
sudo sed -i "s|MONGO_PASSWORD=.*|MONGO_PASSWORD=${MONGO_PASSWORD}|" ./.env
sudo sed -i "s|REDIS_PASSWORD=.*|REDIS_PASSWORD=${REDIS_PASSWORD}|" ./.env
sudo sed -i "s|SMTP_SERVER=.*|SMTP_SERVER=${SMTP_SERVER}|" ./.env
sudo sed -i "s|SMTP_PORT=.*|SMTP_PORT=${SMTP_PORT}|" ./.env
sudo sed -i "s|SMTP_USERNAME=.*|SMTP_USERNAME=${SMTP_USERNAME}|" ./.env
sudo sed -i "s|SMTP_PASSWORD=.*|SMTP_PASSWORD=${SMTP_PASSWORD}|" ./.env

echo "Setting up Myriad webserver and related services..."
sudo docker compose -p myriad -f ./.maintain/deployment/docker-compose.yaml --env-file ./.env --profile webserver up -d

echo "Setting folder permissions..."
sudo chown -R 1001 ./.local/storages

echo "Running database migration..."
sudo docker compose -p myriad -f ./.maintain/deployment/docker-compose.yaml --env-file ./.env run --rm db_migration --rebuild --environment mainnet

echo "Initializing webserver..."
if ! sudo ./.maintain/deployment/init-webserver.sh; then
  echo "Webserver initialization failed. Retrying after removing certbot and nginx folders..."
  sudo rm -rf ./.local/certbot ./.local/nginx
fi
if ! sudo ./.maintain/deployment/init-webserver.sh; then
  echo "Webserver initialization failed. Fix any errors you see above and try rerunning the script, or run the following command directly from the myriad-api folder:"
  echo "   sudo ./.maintain/deployment/init-webserver.sh"
  echo ""
  echo "If the installation continues to fail, run:"
  echo "./myriaduninstall.sh."
fi
