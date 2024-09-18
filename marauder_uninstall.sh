#!/bin/bash

# marauder_uninstall.sh - Final script to uninstall all Marauder components

set -e

echo "Starting Marauder uninstallation process..."

# Function to ask for confirmation
confirm_action() {
    read -p "Do you want to $1? (y/n): " choice
    case "$choice" in 
        y|Y ) return 0;;
        n|N ) return 1;;
        * ) echo "Invalid input. Skipping action."; return 1;;
    esac
}

# Function to extract Docker image tag from docker-compose.yml
get_image_tag() {
    grep -m 1 "image: myriadsocial/$1:" myriad-setup/docker-compose.yml | awk -F ':' '{print $NF}'
}

# Stop and remove Docker containers and volumes (nuke command)
if confirm_action "stop and remove all Docker containers and volumes"; then
    echo "Stopping and removing all Docker containers and volumes..."
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
    docker volume rm $(docker volume ls -q)
fi

# Stop Myriad service
if confirm_action "stop Myriad service"; then
    echo "Stopping Myriad service..."
    sudo systemctl stop myriad-social.service
fi

# Remove Docker images (only Marauder-related)
if confirm_action "remove Marauder-related Docker images"; then
    echo "Removing Marauder-related Docker images..."
    api_tag=$(get_image_tag "myriad-api")
    web_tag=$(get_image_tag "myriad-web")
    docker rmi myriadsocial/myriad-api:$api_tag \
              myriadsocial/myriad-web:$web_tag \
              mongo:latest \
              minio/minio:latest
fi

# Disable and remove zrok
if confirm_action "disable and remove zrok"; then
    echo "Disabling and removing zrok..."
    if [ -d "zrok" ]; then
        cd zrok
        ./zrok disable
        cd ..
        rm -rf zrok
    fi
    rm -f zrok_0.4.40_linux_amd64.tar.gz
fi

# Remove Myriad service
if confirm_action "remove Myriad service"; then
    echo "Removing Myriad service..."
    sudo systemctl disable myriad-social.service
    sudo rm -f /etc/systemd/system/myriad-social.service
    sudo systemctl daemon-reload
fi

# Remove all downloaded files and directories, including docker-compose.yml
if confirm_action "remove all Marauder-related files and directories"; then
    echo "Removing all Marauder-related files and directories..."
    rm -rf mongodb
    rm -f marauder.sh
    rm -f setup_*.sh
    rm -f install_*.sh
    rm -f run_docker_compose.sh
    rm -f download_files.sh
    rm -f adduser.sh
    rm -f myriad-social.service
    
    # Remove myriad-setup directory and its contents
    rm -rf myriad-setup
fi

echo "Marauder uninstallation completed successfully!"
echo "Note: Docker and Docker Compose CLIs have been preserved."
echo "Note: mongorestore was not uninstalled. You may want to manually remove it if it's no longer needed."
echo "You may want to manually remove any remaining data volumes if they're no longer needed."