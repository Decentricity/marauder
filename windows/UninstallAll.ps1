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
    Stop-Process -Name "ngrok" -Force
    
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

# Prompt the user
$answer = Read-Host "Do you want the script to access the registry and uninstall Git & NVM for you? (Y/N)"

# Check the answer
if ($answer -eq "Y") {
    $programs = @()

    # Check both 32-bit and 64-bit registry paths for uninstallers
    $registryPaths = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall",
        "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
    )

    foreach ($path in $registryPaths) {
        $programs += Get-ChildItem -Path $path | 
                    ForEach-Object { Get-ItemProperty -Path $_.PsPath }
    }

    # Filter out Git and NVM
    $appsToUninstall = $programs | Where-Object { $_.DisplayName -match "Git" -or $_.DisplayName -match "nvm for windows" }

    foreach ($app in $appsToUninstall) {
        $answer = Read-Host "Found $($app.DisplayName) with uninstall string: $($app.UninstallString). Do you want the script to continue with the uninstallation? (Y/N)"

        # Check the answer
        if ($answer -eq "Y") {
            # Execute the uninstall command
            if ($app.UninstallString) {
                Start-Process -Wait -FilePath "cmd.exe" -ArgumentList "/c $($app.UninstallString)"
            }
        } else {
            Write-Host "Uninstallation skipped."
        }
    }
} else {
    Write-Host "Git and NVM uninstallation skipped."
    exit
}

Write-Host "Uninstallation process initiated."
