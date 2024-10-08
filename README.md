# marauder.sh (Myriad Setup Script)

## Overview

This script automates the setup process for the Myriad social platform infrastructure on Linux systems. It downloads and executes a series of scripts to install and configure all necessary components for running Myriad.

## Prerequisites

- A Linux-based operating system
- Bash shell
- Internet connection
- curl installed

## Installation

To run the Myriad setup script, use the following command:

```bash
wget --no-cache https://raw.githubusercontent.com/Decentricity/marauder/main/marauder.sh
chmod +x ./marauder.sh
./marauder.sh
```

These commands download and execute the `marauder.sh` script.

## What the Script Does

The `marauder.sh` script performs the following actions:

1. Creates a directory for setup scripts
2. Downloads the following scripts from the Myriad GitHub repository:
   - install_docker.sh
   - install_docker_compose.sh
   - install_zrok.sh
   - download_files.sh
   - setup_minio.sh
   - setup_mongodb.sh
   - setup_myriad_service.sh
   - run_docker_compose.sh
3. Downloads the `myriad-social.service` file
4. Makes all scripts executable
5. Runs each script in order, asking for confirmation before each step

## Script Components

- `marauder.sh`: The main script that orchestrates the entire setup process
- `marauder_uninstall.sh`: Script to uninstall Marauder components (see Uninstallation section)

## User Interaction

The script will prompt the user for confirmation before running each component script. Users can choose to skip any step if desired.

## Error Handling

If any script fails during execution, the user will be prompted to decide whether to continue with the setup process or exit.

## Post-Installation

After successful completion, the script will display a message indicating that the Myriad setup has been completed.

## Uninstallation

To uninstall Marauder and its components, use the following commands:

```bash
wget --no-cache https://raw.githubusercontent.com/Decentricity/marauder/main/marauder_uninstall.sh
chmod +x ./marauder_uninstall.sh
./marauder_uninstall.sh
```

The uninstall script will remove all Marauder-related components, including Docker containers, images, and downloaded files. It will also disable and remove zrok, and remove the Myriad service.

## Windows Installation

A Windows installer for Marauder is currently in development. The scripts for this installer can be found in the `windows` directory. Please note that this is a work in progress and may not be fully functional yet.

## Support

For issues, questions, or contributions, please visit the [Myriad Infrastructure GitHub repository](https://github.com/myriadsocial/myriad-infrastructure).

## Disclaimer

This script downloads and executes code from the internet. Always review scripts before running them on your system. Use at your own risk.