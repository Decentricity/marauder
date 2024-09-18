# 🚧 Myriad Windows Setup Scripts (Work in Progress) 🚧

## Overview

This folder contains PowerShell scripts for setting up the Myriad social platform infrastructure on Windows systems. These scripts automate the installation and configuration of necessary components for running Myriad on Windows.

## Directory Structure

```
windows/
├── InstallMongo.ps1
├── InstallYarnAndGit.ps1
├── README.md
├── InstallMyriadAndNgrok.ps1
├── StartInstallation.ps1
├── InstallNode.ps1
└── UninstallAll.ps1
```

## Script Descriptions

1. `StartInstallation.ps1`: The main script that orchestrates the entire setup process.
2. `InstallNode.ps1`: Installs Node.js on the system.
3. `InstallYarnAndGit.ps1`: Installs Yarn package manager and Git version control.
4. `InstallMongo.ps1`: Installs and configures MongoDB.
5. `InstallMyriadAndNgrok.ps1`: Installs the Myriad application and ngrok for tunneling.
6. `UninstallAll.ps1`: Removes the Myriad installation and its components.

## Prerequisites

- Windows operating system
- PowerShell 5.1 or later
- Administrative privileges

## Installation

1. Open PowerShell as Administrator.
2. Navigate to the `windows` folder.
3. Run the following command:

```powershell
.\StartInstallation.ps1
```

This will initiate the installation process and run through all the necessary scripts.

## Usage

Each script can also be run individually if you need to install or update specific components:

```powershell
.\InstallNode.ps1
.\InstallYarnAndGit.ps1
.\InstallMongo.ps1
.\InstallMyriadAndNgrok.ps1
```

## Uninstallation

To remove the Myriad installation and its components, run:

```powershell
.\UninstallAll.ps1
```

## Error Handling

If any script encounters an error during execution, it will display an error message and may prompt for user input to continue or abort the process.

## Work in Progress

Please note that these scripts are currently a work in progress. Some features may be incomplete or subject to change. We recommend checking for updates regularly and reading any additional documentation provided with the scripts.

## Contributions

Contributions to improve these scripts are welcome. Please submit pull requests or issues to the project's GitHub repository.

## Support

For issues, questions, or contributions, please visit the [Myriad Infrastructure GitHub repository](https://github.com/myriadsocial/myriad-infrastructure).

## Disclaimer

These scripts modify system settings and install software. Always review scripts before running them on your system, especially with administrative privileges. Use at your own risk.