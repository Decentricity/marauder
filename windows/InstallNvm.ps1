# InstallNvm.ps1

# Ensure the script stops on any errors
$ErrorActionPreference = "Stop"

# Define the directory path
$directoryPath = "D:\temp"

# Create the directory if it doesn't exist
if (-not (Test-Path $directoryPath)) {
    New-Item -Path $directoryPath -ItemType Directory
    Write-Output "Directory $directoryPath created successfully!"
} else {
    Write-Output "Directory $directoryPath already exists!"
}

# Check if nvm is already installed
if (-not (Get-Command nvm -ErrorAction SilentlyContinue)) {
    # Define the URL for nvm-windows
    $nvmUrl = "https://github.com/coreybutler/nvm-windows/releases/download/1.1.7/nvm-setup.zip"

    # Define paths for the downloaded zip and the extracted setup file
    $nvmZipPath = "D:\temp\nvm-setup.zip"
    $nvmSetupPath = "D:\temp\nvm-setup.exe"

    # Download nvm-windows
    Invoke-WebRequest -Uri $nvmUrl -OutFile $nvmZipPath

    # Extract the setup file
    Expand-Archive -Path $nvmZipPath -DestinationPath "D:\temp"

    # Install nvm-windows
    Start-Process -FilePath $nvmSetupPath -Wait

    # # Clean up downloaded and extracted files
    # Remove-Item -Path $nvmZipPath
    # Remove-Item -Path $nvmSetupPath

    Write-Host "nvm-windows installation completed!"
}

# Ensure nvm command is available in the current session
if (-not (Get-Command nvm -ErrorAction SilentlyContinue)) {
    $env:Path += ";$env:USERPROFILE\AppData\Roaming\nvm"
}