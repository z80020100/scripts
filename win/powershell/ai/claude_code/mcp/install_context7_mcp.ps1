# Install context7 MCP server for Claude Code
# Reference: https://docs.anthropic.com/en/docs/claude-code/mcp

Write-Host "Installing context7 MCP server..." -ForegroundColor Green

try {
    # Check if Claude Code is installed
    $claudeCheck = Get-Command claude -ErrorAction SilentlyContinue
    if (-not $claudeCheck) {
        Write-Host "Error: Claude Code is not installed. Please install Claude Code first." -ForegroundColor Red
        Write-Host "Run: ..\install_claude_code.ps1" -ForegroundColor Yellow
        exit 1
    }

    # Install context7 MCP server
    claude mcp add -s user context7 -- npx -y @upstash/context7-mcp

    if ($LASTEXITCODE -eq 0) {
        Write-Host "context7 MCP server installed successfully!" -ForegroundColor Green
        Write-Host "You can now use context7 to retrieve up-to-date documentation for any library." -ForegroundColor Green
    }
    else {
        Write-Host "Failed to install context7 MCP server." -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
    exit 1
}
