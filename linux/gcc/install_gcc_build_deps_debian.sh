#!/bin/bash

# https://gcc.gnu.org/install/prerequisites.html

# Install GCC build dependencies
install_dependencies() {
  echo "Installing GCC build dependencies..."
  sudo apt update && sudo apt install -y bison build-essential flex zlib1g-dev git wget
  echo "Dependencies installed successfully"
}

# Check if git user name and email are configured
check_git_config() {
  local git_name=$(git config --global user.name)
  local git_email=$(git config --global user.email)

  if [ -z "$git_name" ]; then
    echo "Git user name is not configured"
    read -p "Please enter your git user name: " input_name
    git config --global user.name "$input_name"
    echo "Git user name set to: $input_name"
  else
    echo "Git user name: $git_name"
  fi

  if [ -z "$git_email" ]; then
    echo "Git user email is not configured"
    read -p "Please enter your git user email: " input_email
    git config --global user.email "$input_email"
    echo "Git user email set to: $input_email"
  else
    echo "Git user email: $git_email"
  fi
}

main() {
  install_dependencies
  check_git_config
}

main
