#!/bin/bash

# Install @hackmd/codimd-cli
# https://www.npmjs.com/package/@hackmd/codimd-cli

echo "Installing @hackmd/codimd-cli..."
npm install -g @hackmd/codimd-cli

# Check if installation was successful
if command -v codimd-cli &>/dev/null; then
    echo "@hackmd/codimd-cli installed successfully!"
    # Create config directory if it doesn't exist
    mkdir -p ~/.codimd
    # Create empty config file if it doesn't exist
    if [ ! -f ~/.codimd/config.json ]; then
        echo '{}' >~/.codimd/config.json
    fi
    echo "Config file created at ~/.codimd/config.json"
else
    echo "Installation failed!"
    exit 1
fi
