#!/bin/sh

echo "Stopping Myriad services..."
sudo docker compose -p myriad -f ./myriad-api/.maintain/deployment/docker-compose.yaml --env-file ./myriad-api/.env down

echo "Removing Myriad repository..."
sudo rm -rf ./myriad-api

echo "Removing Docker settings..."
sudo rm /etc/apt/keyrings/docker.gpg
sudo rm /etc/apt/sources.list.d/docker.list

echo "Cleaning up unused Docker resources..."
sudo docker system prune -a --volumes

echo "Uninstallation complete."

