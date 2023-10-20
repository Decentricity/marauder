function Refresh-Me {
    $envVariables = Get-ChildItem -Path Env: | ForEach-Object { $_.Name }
    foreach ($variable in $envVariables) {
        Set-Variable -Name "env:$variable" -Value ([System.Environment]::GetEnvironmentVariable($variable)) -Scope Global
    }

    Write-Host "Environment Path refreshed."
}

# Ensure the script stops on any errors
$ErrorActionPreference = "Stop"

$mongoDBBinPath = "C:\Program Files\MongoDB\Server\7.0\bin"  # Adjust the version number if needed

# Check if the path exists
if (-not (Test-Path $mongoDBBinPath)) {
    # Install MongoDB
    $mongoDbVersion = "7.0.2"
    $installerUrl = "https://fastdl.mongodb.org/windows/mongodb-windows-x86_64-$mongoDbVersion-signed.msi"
    $installerPath = "D:\temp\mongodb-installer.msi"

    if (-not (Test-Path $installerPath)) {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath
    }
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $installerPath" -Wait

    Write-Host "MongoDB installation completed!"

    Refresh-Me
}
