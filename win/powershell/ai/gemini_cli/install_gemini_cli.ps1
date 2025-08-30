# Install Gemini CLI using npm (Windows)
# Reference: https://google-gemini.github.io/gemini-cli/

Write-Host "Installing Gemini CLI..." -ForegroundColor Green

try {
    # Check if npm is installed
    $npmCheck = Get-Command npm -ErrorAction SilentlyContinue
    if (-not $npmCheck) {
        Write-Host "Error: npm is not installed. Please install Node.js and npm first." -ForegroundColor Red
        Write-Host "Node.js version 20 or higher is required." -ForegroundColor Yellow
        exit 1
    }

    # Check Node.js version
    $nodeVersion = node --version
    $versionNumber = [int]($nodeVersion -replace 'v(\d+)\..*', '$1')
    if ($versionNumber -lt 20) {
        Write-Host "Error: Node.js version 20 or higher is required. Current version: $nodeVersion" -ForegroundColor Red
        exit 1
    }

    # Install Gemini CLI globally
    npm install -g @google/gemini-cli

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Gemini CLI installed successfully!" -ForegroundColor Green
        Write-Host "You can now use 'gemini' command." -ForegroundColor Green
        Write-Host "Run 'gemini --help' for more information." -ForegroundColor Green
    }
    else {
        Write-Host "Failed to install Gemini CLI." -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
    exit 1
}
