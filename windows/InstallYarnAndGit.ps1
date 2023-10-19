function Refresh-Me {
    $envVariables = Get-ChildItem -Path Env: | ForEach-Object { $_.Name }
    foreach ($variable in $envVariables) {
        Set-Variable -Name "env:$variable" -Value ([System.Environment]::GetEnvironmentVariable($variable)) -Scope Global
    }

    Write-Host "Environment Path refreshed."
}

# Ensure the script stops on any errors
$ErrorActionPreference = "Stop"

# Check if npm is already installed
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    # Notify the user
    Write-Host "npm is not installed on this system." -ForegroundColor Red

    # Exit the PowerShell process
    exit
}

# Check if yarn is already installed
if (-not (Get-Command yarn -ErrorAction SilentlyContinue)) {
    # Install Yarn globally using npm
    npm install -g yarn

    Write-Host "Yarn installation completed!"
}


# Check if git is already installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    # Install Git
    $gitInstallerUrl = "https://github.com/git-for-windows/git/releases/download/v2.33.0.windows.2/Git-2.33.0.2-64-bit.exe"
    $gitInstallerPath = "D:\temp\git-installer.exe"

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $gitInstallerUrl -OutFile $gitInstallerPath
    Start-Process -FilePath $gitInstallerPath -ArgumentList "/VERYSILENT" -Wait

    Write-Host "Git installation completed!"

    Refresh-Me

    # Start the new PowerShell instance with the same script
    $scriptPath = ".\InstallMongo.ps1"
    Start-Process -FilePath "powershell" -ArgumentList "-NoExit", "-ExecutionPolicy Bypass", "-File $scriptPath"
    Stop-Process -Id $PID
}

# \\wsl.localhost\Ubuntu-20.04\home\agustinustheoo\work\marauder\windows