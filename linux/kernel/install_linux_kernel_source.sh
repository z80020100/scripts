#!/bin/bash

BUILD_DIR=$HOME/build
LINUX_DIR=$BUILD_DIR/linux

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

function install_kernel_modules() {
  cd $LINUX_DIR
  sudo make modules_install
}

function install_kernel_headers() {
  cd $LINUX_DIR
  sudo make headers_install
}

function install_kernel() {
  cd $LINUX_DIR
  sudo make install
}

function main() {
  check_result install_kernel_modules
  check_result install_kernel_headers
  check_result install_kernel
}

main
