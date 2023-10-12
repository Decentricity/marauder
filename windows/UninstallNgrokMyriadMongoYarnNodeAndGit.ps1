# UninstallNodeMongoGitAndYarn.ps1

# Ensure the script stops on any errors
$ErrorActionPreference = "Stop"

# Kill all jobs (TODO: too brash need to fine tune later)
Get-Job | Stop-Job
Get-Job | Remove-Job

# Remove 'ngrok' directory and the cloned repositories
$ngrokDirectory = "D:\temp\ngrok"
$ngrokZipDirectory = "D:\temp\ngrok.zip"
if (Test-Path $ngrokDirectory) {
    Remove-Item -Path $ngrokDirectory -Recurse -Force
    Remove-Item -Path $ngrokZipDirectory
    Write-Host "ngrok directory and repositories removed successfully!"
}

# Remove 'myriad' directory and the cloned repositories
$myriadDirectory = "D:\myriad"
if (Test-Path $myriadDirectory) {
    Remove-Item -Path $myriadDirectory -Recurse -Force
    Write-Host "Myriad directory and repositories removed successfully!"
}

# Uninstall MongoDB
$installerPath = "D:\temp\mongodb-installer.msi"

Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $installerPath" -Wait

Write-Host "MongoDB uninstallation initiated. Depending on your system, MongoDB might still appear in the list of installed programs until the next restart."

# Uninstall Yarn globally
npm uninstall -g yarn
Write-Host "Yarn global uninstallation completed!"

# Check if nvm is available
if (Get-Command nvm -ErrorAction SilentlyContinue) {
    # Uninstall Node.js version
    $nvmVersion = "14.17"
    nvm uninstall $nvmVersion

    Write-Host "Node.js version $nvmVersion uninstallation completed!"

    # Note: Uninstalling `nvm-windows` itself requires manual removal due to the design of `nvm-windows`.
    Write-Host "To fully uninstall nvm-windows, please manually delete the nvm directory (typically located in D:\Users\YourUsername\AppData\Roaming\nvm) and remove NVM_HOME & NVM_SYMLINK environment variables."
}

# Uninstall Git
# The next lines guide the user to do it as there isn't a universal silent un-installation method.
Write-Host "To uninstall Git, please go to 'Add or Remove Programs' in Windows, find 'Git', and choose to uninstall."

Write-Host "Uninstallation script completed!"
