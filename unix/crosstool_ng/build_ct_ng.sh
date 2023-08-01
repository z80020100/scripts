#!/bin/bash

# https://github.com/crosstool-ng/crosstool-ng/blob/master/.github/workflows/continuous-integration-workflow.yml

OS=$(uname -s)
ARCH=$(uname -m)
DARWIN_LIB_PATH_ARM64=/opt/homebrew/opt/
DARWIN_LIB_PATH_X86_64=/usr/local/opt/
if [ "$ARCH" == "arm64" ]; then
  DARWIN_LIB_PATH=$DARWIN_LIB_PATH_ARM64
else # x86_64
  DARWIN_LIB_PATH=$DARWIN_LIB_PATH_X86_64
fi
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
  if [ "$OS" == "Darwin" ]; then
    export PATH="$PATH:$DARWIN_LIB_PATH/binutils/bin"
    export CPPFLAGS="-I$DARWIN_LIB_PATH/ncurses/include -I$DARWIN_LIB_PATH/gettext/include"
    export LDFLAGS="-L$DARWIN_LIB_PATH/ncurses/lib -L$DARWIN_LIB_PATH/gettext/lib"
  fi
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
