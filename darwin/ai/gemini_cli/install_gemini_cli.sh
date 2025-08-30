#!/bin/bash
# Install Gemini CLI using Homebrew (macOS)
# Reference: https://google-gemini.github.io/gemini-cli/

set -e

echo "Installing Gemini CLI using Homebrew..."

if ! command -v brew &>/dev/null; then
    echo "Error: Homebrew is not installed. Please install Homebrew first."
    echo "Visit: https://brew.sh/"
    exit 1
fi

brew install gemini-cli

if [ $? -eq 0 ]; then
    echo "Gemini CLI installed successfully!"
    echo "You can now use 'gemini' command."
    echo "Run 'gemini --help' for more information."
else
    echo "Failed to install Gemini CLI."
    exit 1
fi
