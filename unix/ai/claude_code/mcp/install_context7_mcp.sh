#!/bin/bash
# Install context7 MCP server for Claude Code
# Reference: https://docs.anthropic.com/en/docs/claude-code/mcp

set -e

echo "Installing context7 MCP server..."

# Check if Claude Code is installed
if ! command -v claude &>/dev/null; then
    echo "Error: Claude Code is not installed. Please install Claude Code first."
    echo "Run: ../install_claude_code.sh"
    exit 1
fi

# Install context7 MCP server
claude mcp add -s user context7 -- npx -y @upstash/context7-mcp

if [ $? -eq 0 ]; then
    echo "context7 MCP server installed successfully!"
    echo "You can now use context7 to retrieve up-to-date documentation for any library."
else
    echo "Failed to install context7 MCP server."
    exit 1
fi
