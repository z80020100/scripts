# Install Claude Code CLI
# Reference: https://docs.anthropic.com/en/docs/claude-code/setup

Write-Host "Installing Claude Code..." -ForegroundColor Green

try {
    # Check if npm is installed
    $npmCheck = Get-Command npm -ErrorAction SilentlyContinue
    if (-not $npmCheck) {
        Write-Host "Error: npm is not installed. Please install Node.js and npm first." -ForegroundColor Red
        exit 1
    }

    # Install Claude Code globally
    npm install -g @anthropic-ai/claude-code

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Claude Code installed successfully!" -ForegroundColor Green
        Write-Host "You can now use 'claude' command." -ForegroundColor Green
    } else {
        Write-Host "Failed to install Claude Code." -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
    exit 1
}
