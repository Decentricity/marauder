function Refresh-Me {
    $envVariables = Get-ChildItem -Path Env: | ForEach-Object { $_.Name }
    foreach ($variable in $envVariables) {
        Set-Variable -Name "env:$variable" -Value ([System.Environment]::GetEnvironmentVariable($variable)) -Scope Global
    }

    Write-Host "Environment Path refreshed."
}

# Ensure the script stops on any errors
$ErrorActionPreference = "Stop"

# Check if nvm is already installed
if (-not (Get-Command nvm -ErrorAction SilentlyContinue)) {
    # Notify the user
    Write-Host "nvm is not installed on this system." -ForegroundColor Red

    # Exit the PowerShell process
    exit
}

# Check if node is already installed
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    # Install the desired Node.js version
    $nvmVersion = "14.17"
    nvm install $nvmVersion
    nvm use $nvmVersion

    Write-Host "Node.js version $nvmVersion installation completed!"

    Refresh-Me

    # Start the new PowerShell instance with the same script
    $scriptPath = ".\InstallYarnAndGit.ps1"
    Start-Process -FilePath "powershell" -ArgumentList "-NoExit", "-ExecutionPolicy Bypass", "-File $scriptPath"
    Stop-Process -Id $PID
}