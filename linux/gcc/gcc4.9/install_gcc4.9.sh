#!/bin/bash

# Global variable for timing
START_TIME=$(date +%s)

BUILD_DIR=$HOME/build
GCC_TARGET_VERSION="4.9"
GCC_DIR=$BUILD_DIR/gcc$GCC_TARGET_VERSION
GCC_OBJ_DIR=$GCC_DIR/obj
INSTALL_PREFIX="/opt/gcc-$GCC_TARGET_VERSION"

function check_result() {
  $@
  ERR=$?
  printf "$* "
  if [ "$ERR" != "0" ]; then
    echo -e "\033[47;31m [ERROR] $ERR \033[0m"
    END_TIME=$(date +%s)
    ELAPSED_TIME=$((END_TIME - START_TIME))
    echo -e "\033[41;37mInstallation failed after ${ELAPSED_TIME} seconds\033[0m"
    exit 1
  else
    echo -e "\033[1;42m [OK] \033[0m"
  fi
}

check_build_exists() {
  if [ ! -d "$GCC_OBJ_DIR" ] || [ ! -f "$GCC_OBJ_DIR/gcc/xgcc" ]; then
    echo "Build directory not found or incomplete"
    echo "Please run build_gcc4.9.sh first"
    exit 1
  fi
}

create_install_dir() {
  sudo mkdir -p $INSTALL_PREFIX
  sudo chown $USER:$USER $INSTALL_PREFIX
}

install_gcc() {
  cd $GCC_OBJ_DIR
  make install-strip
}

create_environment_script() {
  cat >/tmp/gcc4.9-env.sh <<'EOF'
#!/bin/bash
# GCC 4.9 Environment Setup

export GCC49_HOME="/opt/gcc-4.9"
export PATH="$GCC49_HOME/bin:$PATH"
export LD_LIBRARY_PATH="$GCC49_HOME/lib64:$GCC49_HOME/lib:$LD_LIBRARY_PATH"
export MANPATH="$GCC49_HOME/share/man:$MANPATH"

echo "GCC 4.9 environment loaded"
echo "GCC version: $(gcc-4.9 --version | head -1)"
EOF
  sudo cp /tmp/gcc4.9-env.sh $INSTALL_PREFIX/
  sudo chmod +x $INSTALL_PREFIX/gcc4.9-env.sh
}

function main() {
  check_result check_build_exists
  check_result create_install_dir
  check_result install_gcc
  check_result create_environment_script

  END_TIME=$(date +%s)
  ELAPSED_TIME=$((END_TIME - START_TIME))
  echo -e "\033[1;42m Installation completed successfully in ${ELAPSED_TIME} seconds \033[0m"
  echo
  echo "To use GCC 4.9:"
  echo "  source $INSTALL_PREFIX/gcc4.9-env.sh"
  echo
  echo "Or directly:"
  echo "  $INSTALL_PREFIX/bin/gcc-4.9 --version"
}

main
