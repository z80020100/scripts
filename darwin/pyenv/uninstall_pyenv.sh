#!/bin/bash
# Script to uninstall pyenv on macOS
# Reference: https://github.com/pyenv/pyenv#uninstalling-pyenv

# Remove pyenv root directory
rm -rf $(pyenv root)

# Uninstall pyenv via Homebrew
brew uninstall pyenv

# Remove pyenv configuration from .zshrc
# Get the absolute path of .zshrc
ZSHRC_FILE=$(realpath ~/.zshrc)

# Remove pyenv related lines
sed -i '' '/# pyenv/d' "$ZSHRC_FILE"
sed -i '' '/export PYENV_ROOT/d' "$ZSHRC_FILE"
sed -i '' '/\[\[ -d \$PYENV_ROOT\/bin \]\]/d' "$ZSHRC_FILE"
sed -i '' '/eval "\$(pyenv init - zsh)"/d' "$ZSHRC_FILE"
