#!/bin/bash

# Install @hackmd/hackmd-cli
# https://www.npmjs.com/package/@hackmd/hackmd-cli

echo "Installing @hackmd/hackmd-cli..."
npm install -g @hackmd/hackmd-cli

# Check if installation was successful
if command -v hackmd-cli &>/dev/null; then
    echo "@hackmd/hackmd-cli installed successfully!"
    echo "Version: $(hackmd-cli --version)"
else
    echo "Installation failed!"
    exit 1
fi
