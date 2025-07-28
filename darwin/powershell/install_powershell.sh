#!/bin/bash

# Install PowerShell via Homebrew Cask
# Ref: https://learn.microsoft.com/ja-jp/powershell/scripting/install/installing-powershell-on-macos

set -e

echo "Installing PowerShell via Homebrew Cask..."

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
    echo "Error: Homebrew is not installed. Please install Homebrew first."
    exit 1
fi

# Install PowerShell
brew install --cask powershell

echo "PowerShell installation completed!"
echo "You can now run PowerShell with 'pwsh' command."
