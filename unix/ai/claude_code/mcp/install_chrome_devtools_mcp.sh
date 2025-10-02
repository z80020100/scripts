#!/bin/bash
# Install Chrome DevTools MCP server for Claude Code
# Reference: https://developer.chrome.com/blog/chrome-devtools-mcp

set -e

echo "Installing Chrome DevTools MCP server..."

# Check if Claude Code is installed
if ! command -v claude &>/dev/null; then
    echo "Error: Claude Code is not installed. Please install Claude Code first."
    echo "Run: ../install_claude_code.sh"
    exit 1
fi

# Install Chrome DevTools MCP server
claude mcp add -s user chrome-devtools -- npx chrome-devtools-mcp@latest

if [ $? -eq 0 ]; then
    echo "Chrome DevTools MCP server installed successfully!"
    echo ""
    echo "Usage:"
    echo "  - Test with: 'Please check the LCP of web.dev'"
    echo "  - Documentation: https://github.com/ChromeDevTools/chrome-devtools-mcp/"
    echo "  - Tool reference: https://github.com/ChromeDevTools/chrome-devtools-mcp/blob/main/docs/tool-reference.md"
else
    echo "Failed to install Chrome DevTools MCP server."
    exit 1
fi
