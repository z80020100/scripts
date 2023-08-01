#!/bin/bash

# https://github.com/crosstool-ng/crosstool-ng/blob/master/.github/workflows/continuous-integration-workflow.yml

BUILD_DIR=$HOME/build
CT_NG_DIR=$BUILD_DIR/crosstool-ng
# Load CT_NG_INSTALL_DIR from envsetup.sh
source envsetup.sh

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

function build_ct_ng() {
  cd $CT_NG_DIR
  ./bootstrap
  ./configure --prefix=$CT_NG_INSTALL_DIR
  make
  make install
}

function main() {
  check_result build_ct_ng
}

main
