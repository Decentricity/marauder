# InstallMyriad.ps1

# Ensure the script stops on any errors
$ErrorActionPreference = "Stop"

# Check if npm is already installed
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    # Notify the user
    Write-Host "npm is not installed on this system." -ForegroundColor Red

    # Exit the PowerShell process
    exit
}

# Check if nvm is already installed
if (-not (Get-Command nvm -ErrorAction SilentlyContinue)) {
    # Notify the user
    Write-Host "nvm is not installed on this system." -ForegroundColor Red

    # Exit the PowerShell process
    exit
}

# Check if yarn is already installed
if (-not (Get-Command yarn -ErrorAction SilentlyContinue)) {
    # Notify the user
    Write-Host "yarn is not installed on this system." -ForegroundColor Red

    # Exit the PowerShell process
    exit
}

# Check if git is already installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    # Notify the user
    Write-Host "git is not installed on this system." -ForegroundColor Red

    # Exit the PowerShell process
    exit
}

$mongoDBBinPath = "C:\Program Files\MongoDB\Server\7.0\bin"  # Adjust the version number if needed

if (-not (Test-Path $mongoDBBinPath)) {
    # Notify the user
    Write-Host "MongoDB is not installed on this system." -ForegroundColor Red

    # Exit the PowerShell process
    exit
}

# Prompt the user for the Ngrok authentication token
$ngrokAuthToken = Read-Host -Prompt "Enter your Ngrok authentication token"

# Check if the token is null or empty
if ([string]::IsNullOrEmpty($ngrokAuthToken)) {
    Write-Error "The Ngrok authentication token was not provided. Exiting script."
    exit
}

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

$myriadApi = "D:\myriad\myriad-api"
$myriadWeb = "D:\myriad\myriad-web"

if (-not (Test-Path $myriadApi) -or -not (Test-Path $myriadWeb)) {
    # Clone the repositories
    git clone https://github.com/myriadsocial/myriad-api.git
    git clone https://github.com/myriadsocial/myriad-web.git

    Write-Host "Repositories cloned successfully in the 'myriad' directory!"
}

Set-Location -Path $myriadWeb

$envContent = @"
NODE_ENV=development
HOST=127.0.0.1
PORT=3000

# APP
NEXT_PUBLIC_APP_ENVIRONMENT=testnet
NEXT_PUBLIC_APP_NAME=Myriad App
NEXT_PUBLIC_APP_VERSION=2.1.20
NEXT_PUBLIC_APP_AUTH_URL=http://localhost:3000
APP_SECRET=crOuQ926z0PGP2u4zUC624775d4diXB4

# MYRIAD
NEXT_PUBLIC_MYRIAD_SUPPORT_MAIL=support@myriad.social
NEXT_PUBLIC_MYRIAD_WEBSITE_URL=https://myriad.social
NEXT_PUBLIC_MYRIAD_RPC_URL=wss://ws-rpc.devnet.myriad.social
NEXT_PUBLIC_MYRIAD_API_URL=http://localhost:4000

# TIPPING CONTRACT
NEAR_TIPPING_CONTRACT_ID=myriadtips.testnet

# FIREBASE
NEXT_PUBLIC_FIREBASE_PROJECT_ID=
NEXT_PUBLIC_FIREBASE_API_KEY=
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=
NEXT_PUBLIC_FIREBASE_APP_ID=
NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID=
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=

# SENTRY
NEXT_PUBLIC_SENTRY_DSN=
"@

$envContent | Out-File .env -Encoding utf8


# Navigate to your project directory (replace with your actual path)
Set-Location -Path $myriadApi

$envContent = @"
DOMAIN=localhost

# MYRIAD
MYRIAD_ADMIN_SUBSTRATE_MNEMONIC=
MYRIAD_ADMIN_NEAR_MNEMONIC=

# JWT
JWT_TOKEN_SECRET_KEY=jr6AnWfTcUkQH768
JWT_TOKEN_EXPIRES_IN=36000
JWT_REFRESH_TOKEN_SECRET_KEY=Y2csOsu072uGB5UV
JWT_REFRESH_TOKEN_EXPIRES_IN=216000

# MONGO
MONGO_PROTOCOL=mongodb
MONGO_HOST=localhost
MONGO_PORT=27017
MONGO_USER=
MONGO_PASSWORD=
MONGO_DATABASE=myriad
MONGO_URL=mongodb://localhost:27017/myriad?replicaSet=rs0&w=majority&wtimeoutMS=2000

# REDIS
REDIS_CONNECTOR=
REDIS_HOST=
REDIS_PORT=
REDIS_PASSWORD=

# SMTP
SMTP_SERVER=
SMTP_PORT=
SMTP_USERNAME=
SMTP_PASSWORD=
SMTP_SENDER_ADDRESS=

# FIREBASE
# Path to sevice account credential file, e.g /etc/gcp/sa_credentials.json
GOOGLE_APPLICATION_CREDENTIALS=
FIREBASE_STORAGE_BUCKET=

# SENTRY
SENTRY_DSN=

# TWITTER
TWITTER_API_KEY=

# COIN MARKET CAP
COIN_MARKET_CAP_API_KEY=
"@

$envContent | Out-File .env -Encoding utf8

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
yarn build

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

if (-not (Test-Path $ngrokZipPath) -or -not (Test-Path $ngrokExtractPath)) {
    # Download ngrok
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $ngrokZipUrl -OutFile $ngrokZipPath

    # Extract ngrok
    Expand-Archive -Path $ngrokZipPath -DestinationPath $ngrokExtractPath
}

Start-Process -NoNewWindow -FilePath "$ngrokExtractPath\ngrok.exe" -ArgumentList "authtoken $ngrokAuthToken"

# Run ngrok (example: expose port 3000)
Start-Job -ScriptBlock {
    Start-Process -NoNewWindow -FilePath "D:\temp\ngrok\ngrok.exe" -ArgumentList "http 3000"
}

Write-Host "Ngrok is now running and exposing port 3000!"