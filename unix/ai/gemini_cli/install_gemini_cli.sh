#!/bin/bash
# Install Gemini CLI using npm (cross-platform)
# Reference: https://google-gemini.github.io/gemini-cli/

set -e

echo "Installing Gemini CLI using npm..."

if ! command -v npm &>/dev/null; then
    echo "Error: npm is not installed. Please install Node.js and npm first."
    echo "Node.js version 20 or higher is required."
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 20 ]; then
    echo "Error: Node.js version 20 or higher is required. Current version: $(node --version)"
    exit 1
fi

npm install -g @google/gemini-cli

if [ $? -eq 0 ]; then
    echo "Gemini CLI installed successfully!"
    echo "You can now use 'gemini' command."
    echo "Run 'gemini --help' for more information."
else
    echo "Failed to install Gemini CLI."
    exit 1
fi
