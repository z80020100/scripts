#!/bin/bash

GCC49_INSTALL_PREFIX="/opt/gcc-4.9"

check_installation() {
  if [ ! -d "$GCC49_INSTALL_PREFIX" ] || [ ! -f "$GCC49_INSTALL_PREFIX/bin/gcc-4.9" ]; then
    echo "GCC 4.9 not found in $GCC49_INSTALL_PREFIX"
    echo "Please run install_gcc4.9.sh first"
    exit 1
  fi
}

show_usage() {
  echo "GCC 4.9 Toolchain Management Script"
  echo "======================================"
  echo
  echo "Usage: $0 [COMMAND]"
  echo
  echo "Commands:"
  echo "  env         - Output environment variables setup (for scripting)"
  echo "                Use with: source <($0 env)"
  echo "  version     - Display GCC 4.9 installation info and version"
  echo "  compile     - Interactive compilation with GCC 4.9"
  echo "                Prompts for source file, output file, and flags"
  echo "  shell       - Start new shell with GCC 4.9 environment loaded"
  echo "                Sets CC=gcc-4.9, CXX=g++-4.9, updates PATH"
  echo "  help        - Show this detailed help message"
  echo
  echo "Examples:"
  echo "  $0 version                    # Check installation and version"
  echo "  $0 shell                      # Start GCC 4.9 shell (recommended)"
  echo "  source <($0 env)              # Load environment in current shell"
  echo "  $0 compile                    # Interactive compilation"
  echo
  echo "Installation Path: $GCC49_INSTALL_PREFIX"
  echo
  echo "Note: Run install_gcc4.9.sh first if GCC 4.9 is not installed"
}

show_environment() {
  if [ -f "$GCC49_INSTALL_PREFIX/gcc4.9-env.sh" ]; then
    cat "$GCC49_INSTALL_PREFIX/gcc4.9-env.sh"
  else
    echo "Environment script not found: $GCC49_INSTALL_PREFIX/gcc4.9-env.sh"
    echo "Please run install_gcc4.9.sh first"
    exit 1
  fi
}

show_version() {
  echo "GCC 4.9 Installation Info:"
  echo "  Install Path: $GCC49_INSTALL_PREFIX"
  echo "  GCC Version: $($GCC49_INSTALL_PREFIX/bin/gcc-4.9 --version | head -1)"
  echo "  G++ Version: $($GCC49_INSTALL_PREFIX/bin/g++-4.9 --version | head -1)"
}

interactive_compile() {
  echo "GCC 4.9 Interactive Compiler"
  read -p "Enter source file (default: ../test_gcc_version.c): " source_file
  source_file=${source_file:-../test_gcc_version.c}

  if [ ! -f "$source_file" ]; then
    echo "File not found: $source_file"
    exit 1
  fi

  read -p "Enter output file name (default: test_gcc_version): " output_file
  output_file=${output_file:-test_gcc_version}

  read -p "Enter compiler flags (default: -Wall -g): " flags
  flags=${flags:--Wall -g}

  echo "Compiling with GCC 4.9..."
  echo "Command: $GCC49_INSTALL_PREFIX/bin/gcc-4.9 $flags $source_file -o $output_file"

  $GCC49_INSTALL_PREFIX/bin/gcc-4.9 $flags $source_file -o $output_file

  if [ $? -eq 0 ]; then
    echo "Compilation successful: $output_file"
  else
    echo "Compilation failed"
  fi
}

start_shell() {
  echo "Starting shell with GCC 4.9 environment..."
  echo "Type 'exit' to return to normal environment"

  if [ -f "$GCC49_INSTALL_PREFIX/gcc4.9-env.sh" ]; then
    source "$GCC49_INSTALL_PREFIX/gcc4.9-env.sh"
    export PS1="[GCC4.9] \u@\h:\w\$ "
    bash
  else
    echo "Environment script not found: $GCC49_INSTALL_PREFIX/gcc4.9-env.sh"
    echo "Please run install_gcc4.9.sh first"
    exit 1
  fi
}

check_installation

case "${1:-help}" in
env)
  show_environment
  ;;
version)
  show_version
  ;;
compile)
  interactive_compile
  ;;
shell)
  start_shell
  ;;
help | *)
  show_usage
  ;;
esac
