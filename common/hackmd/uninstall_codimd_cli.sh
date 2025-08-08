#!/bin/bash

# Uninstall @hackmd/codimd-cli
# https://www.npmjs.com/package/@hackmd/codimd-cli

echo "Uninstalling @hackmd/codimd-cli..."
npm uninstall -g @hackmd/codimd-cli

# Check if uninstallation was successful
if ! command -v codimd-cli &>/dev/null; then
    echo "@hackmd/codimd-cli uninstalled successfully!"

    # Ask user if they want to remove config directory
    read -p "Do you want to remove the config directory ~/.codimd? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf ~/.codimd
        echo "Config directory ~/.codimd removed."
    else
        echo "Config directory ~/.codimd preserved."
    fi
else
    echo "Uninstallation failed!"
    exit 1
fi
