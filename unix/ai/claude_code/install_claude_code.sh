#!/bin/bash
# Install Claude Code CLI
# Reference: https://docs.anthropic.com/en/docs/claude-code/setup

set -e

echo "Installing Claude Code..."

if ! command -v npm &>/dev/null; then
    echo "Error: npm is not installed. Please install Node.js and npm first."
    exit 1
fi

npm install -g @anthropic-ai/claude-code

if [ $? -eq 0 ]; then
    echo "Claude Code installed successfully!"
    echo "You can now use 'claude' command."
else
    echo "Failed to install Claude Code."
    exit 1
fi
