# InstallNodeMongoAndYarn.ps1

# Ensure the script stops on any errors
$ErrorActionPreference = "Stop"

# Install the desired Node.js version
$nvmVersion = "14.17"
nvm install $nvmVersion
nvm use $nvmVersion

Write-Host "Node.js version $nvmVersion installation completed!"

# Install Yarn globally using npm
npm install -g yarn

Write-Host "Yarn installation completed!"

# Install MongoDB
$mongoDbVersion = "7.0.2"
$installerUrl = "https://fastdl.mongodb.org/windows/mongodb-windows-x86_64-$mongoDbVersion-signed.msi"
$installerPath = "D:\temp\mongodb-installer.msi"

Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $installerPath" -Wait

Write-Host "MongoDB installation completed!"
