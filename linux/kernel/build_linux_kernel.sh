#!/bin/bash

BUILD_DIR=$HOME/build
LINUX_DIR=$BUILD_DIR/linux
# Reserve 1 core for the system
USE_CORES=$(nproc --ignore=1)

function check_result() {
  $@
  ERR=$?
  printf "$* "
  if [ "$ERR" != "0" ]; then
    echo -e "\033[47;31m [ERROR] $ERR \033[0m"
    exit 1
  else
    echo -e "\033[1;42m [OK] \033[0m"
  fi
}

function show_info() {
  echo "Build directory: $LINUX_DIR"
  echo "Use cores: $USE_CORES"
}

function create_build_dir() {
  mkdir -p $LINUX_DIR
}

function create_config() {
  cd $LINUX_DIR
  cp -v /boot/config-$(uname -r) .config
  scripts/config --disable SYSTEM_TRUSTED_KEYS
  scripts/config --disable SYSTEM_REVOCATION_KEYS
  # Accept defaults for new options
  make olddefconfig
}

function build_all() {
  # https://www.kernel.org/doc/makehelp.txt
  # vmlinux, modules
  cd $LINUX_DIR
  make -j $USE_CORES
}

function main() {
  show_info
  check_result create_build_dir
  check_result create_config
  check_result build_all
}

main
