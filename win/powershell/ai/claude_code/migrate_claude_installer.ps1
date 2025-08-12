# Migrate Claude Code installer
# Reference: https://docs.anthropic.com/en/docs/claude-code/setup#local-installation

Write-Host "Running Claude Code migrate-installer..." -ForegroundColor Green

try {
    # Check if claude command is available
    $claudeCheck = Get-Command claude -ErrorAction SilentlyContinue
    if (-not $claudeCheck) {
        Write-Host "Error: claude command not found. Please install Claude Code first." -ForegroundColor Red
        exit 1
    }

    # Run migrate-installer
    claude migrate-installer

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Claude Code migrate-installer completed successfully!" -ForegroundColor Green
    }
    else {
        Write-Host "Failed to run claude migrate-installer." -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
    exit 1
}
