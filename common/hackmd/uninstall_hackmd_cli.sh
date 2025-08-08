#!/bin/bash

# Uninstall @hackmd/hackmd-cli
# https://www.npmjs.com/package/@hackmd/hackmd-cli

echo "Uninstalling @hackmd/hackmd-cli..."
npm uninstall -g @hackmd/hackmd-cli

# Check if uninstallation was successful
if ! command -v hackmd-cli &>/dev/null; then
    echo "@hackmd/hackmd-cli uninstalled successfully!"
else
    echo "Uninstallation failed!"
    exit 1
fi