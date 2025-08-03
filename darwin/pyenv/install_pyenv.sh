#!/bin/bash
# Script to install pyenv on macOS
# Reference: https://github.com/pyenv/pyenv#homebrew-in-macos

# Install pyenv via Homebrew
brew install pyenv

# Add pyenv to shell configuration
echo '' >>~/.zshrc
echo '# pyenv' >>~/.zshrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >>~/.zshrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >>~/.zshrc
echo 'eval "$(pyenv init - zsh)"' >>~/.zshrc

echo "Please restart your terminal or run 'source ~/.zshrc' in a zsh shell to activate pyenv."
