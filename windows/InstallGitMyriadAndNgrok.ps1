# InstallMyriad.ps1

# Ensure the script stops on any errors
$ErrorActionPreference = "Stop"

# Define the directory path
$dataDirectoryPath = "D:\data"

# Create the directory if it doesn't exist
if (-not (Test-Path $dataDirectoryPath)) {
    New-Item -Path $dataDirectoryPath -ItemType Directory
    Write-Output "Directory $dataDirectoryPath created successfully!"
} else {
    Write-Output "Directory $dataDirectoryPath already exists!"
}

# Define the directory path
$dataDbDirectoryPath = "D:\data\db"

# Create the directory if it doesn't exist
if (-not (Test-Path $dataDbDirectoryPath)) {
    New-Item -Path $dataDbDirectoryPath -ItemType Directory
    Write-Output "Directory $dataDbDirectoryPath created successfully!"
} else {
    Write-Output "Directory $dataDbDirectoryPath already exists!"
}

# Run MongoDB instance with database named "myriad"
$mongoDBBinPath = "C:\Program Files\MongoDB\Server\7.0\bin"  # Adjust the version number if needed
Start-Process -NoNewWindow -FilePath "$mongoDBBinPath\mongod.exe" -ArgumentList "--dbpath D:\data\db", "--bind_ip_all"

Write-Host "MongoDB instance running with database 'myriad'"

# Install Git
$gitInstallerUrl = "https://github.com/git-for-windows/git/releases/download/v2.33.0.windows.2/Git-2.33.0.2-64-bit.exe"
$gitInstallerPath = "D:\temp\git-installer.exe"

Invoke-WebRequest -Uri $gitInstallerUrl -OutFile $gitInstallerPath
Start-Process -FilePath $gitInstallerPath -ArgumentList "/VERYSILENT" -Wait

Write-Host "Git installation completed!"

# Create a 'myriad' directory and clone the repositories
$myriadDirectory = "D:\myriad"

# Create the directory if it doesn't exist
if (-not (Test-Path $myriadDirectory)) {
    New-Item -Path $myriadDirectory -ItemType Directory
    Write-Output "Directory $myriadDirectory created successfully!"
} else {
    Write-Output "Directory $myriadDirectory already exists!"
}

Set-Location -Path $myriadDirectory

# Clone the repositories
git clone https://github.com/myriadsocial/myriad-api.git
git clone https://github.com/myriadsocial/myriad-web.git

Write-Host "Repositories cloned successfully in the 'myriad' directory!"

# Navigate to your project directory (replace with your actual path)
$projectPath = "D:\myriad\myriad-api"

cd $projectPath

# Install dependencies as per your project's requirements
yarn install --frozen-lockfile --ignore-engines --network-timeout 100000
yarn build

Start-Job -ScriptBlock {
    Set-Location "D:\myriad\myriad-api"
    node .
}

Write-Host "Successfully ran 'myriad-api'!"

# Navigate to your project directory (replace with your actual path)
$projectPath = "D:\myriad\myriad-web"

cd $projectPath

# Install dependencies as per your project's requirements
yarn install --frozen-lockfile --ignore-engines --network-timeout 100000
# yarn build

Start-Job -ScriptBlock {
    Set-Location "D:\myriad\myriad-web"
    yarn start
}

Write-Host "Successfully ran 'myriad-web'!"

# Define the URL for ngrok's zip for Windows
$ngrokZipUrl = "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip"

# Define paths for the downloaded zip and extraction
$ngrokZipPath = "D:\temp\ngrok.zip"
$ngrokExtractPath = "D:\temp\ngrok"

# Download ngrok
Invoke-WebRequest -Uri $ngrokZipUrl -OutFile $ngrokZipPath

# Extract ngrok
Expand-Archive -Path $ngrokZipPath -DestinationPath $ngrokExtractPath

Start-Process -NoNewWindow -FilePath "$ngrokExtractPath\ngrok.exe" -ArgumentList "authtoken *auth token*"

# Run ngrok (example: expose port 3000)
Start-Job -ScriptBlock {
    Start-Process -NoNewWindow -FilePath "D:\temp\ngrok\ngrok.exe" -ArgumentList "http 3000"
}

Write-Host "Ngrok is now running and exposing port 3000!"