#!/bin/bash
# Migrate Claude Code installer
# Reference: https://docs.anthropic.com/en/docs/claude-code/setup#local-installation

set -e

echo "Running Claude Code migrate-installer..."

if ! command -v claude &>/dev/null; then
    echo "Error: claude command not found. Please install Claude Code first."
    exit 1
fi

claude migrate-installer

if [ $? -eq 0 ]; then
    echo "Claude Code migrate-installer completed successfully!"
else
    echo "Failed to run claude migrate-installer."
    exit 1
fi
