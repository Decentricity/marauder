function Refresh-Me {
    $envVariables = Get-ChildItem -Path Env: | ForEach-Object { $_.Name }
    foreach ($variable in $envVariables) {
        Set-Variable -Name "env:$variable" -Value ([System.Environment]::GetEnvironmentVariable($variable)) -Scope Global
    }

    Write-Host "Environment Path refreshed."
}

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

    if (-not (Test-Path $nvmZipPath) -or -not (Test-Path $nvmSetupPath)) {
        # Download nvm-windows
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $nvmUrl -OutFile $nvmZipPath

        # Extract the setup file
        Expand-Archive -Path $nvmZipPath -DestinationPath "D:\temp"
    }

    # Install nvm-windows
    Start-Process -FilePath $nvmSetupPath -Wait
    
}

Refresh-Me

# Start the new PowerShell instance with the same script
$scriptPath = ".\InstallNode.ps1"
Start-Process -FilePath "powershell" -ArgumentList "-NoExit", "-ExecutionPolicy Bypass", "-File $scriptPath"
Stop-Process -Id $PID