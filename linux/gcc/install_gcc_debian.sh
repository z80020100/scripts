#!/bin/bash
DISTRIB_CODENAME=$(lsb_release -c -s)
ARCH=$(uname -m)
GCC_DEFAULT_VERSION=""
GCC_TARGET_VERSION=$GCC_DEFAULT_VERSION
GCC_VERSION_AVAILABLE_JAMMY=("9" "10" "11" "12")
GCC_VERSION_AVAILABLE_FOCAL=("9" "10")
GCC_DEFAULT_ARCH=""
GCC_TARGET_ARCH=$GCC_DEFAULT_ARCH
ARCH_LIST=("x86_64" "aarch64")

function parse_available_versions() {
  GCC_VERSION_AVAILABLE=""
  if [ "$DISTRIB_CODENAME" == "jammy" ]; then
    VERSION_LIST=("${GCC_VERSION_AVAILABLE_JAMMY[@]}")
  elif [ "$DISTRIB_CODENAME" == "focal" ]; then
    VERSION_LIST=("${GCC_VERSION_AVAILABLE_FOCAL[@]}")
  else
    VERSION_LIST=("unknown")
  fi
  for version in "${VERSION_LIST[@]}"; do
    GCC_VERSION_AVAILABLE+="$version, "
  done
  GCC_VERSION_AVAILABLE="${GCC_VERSION_AVAILABLE%, }"
}

function parse_available_arch() {
  GCC_ARCH_AVAILABLE=""
  for arch in "${ARCH_LIST[@]}"; do
    GCC_ARCH_AVAILABLE+="$arch, "
  done
  GCC_ARCH_AVAILABLE="${GCC_ARCH_AVAILABLE%, }"
}

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

function parse_params() {
  while [ "$1" ]; do
    case "$1" in
    --help | -h)
      usage
      exit 0
      ;;
    --version | -v)
      if [[ " ${VERSION_LIST[@]} " =~ " ${2} " ]]; then
        GCC_TARGET_VERSION="$2"
      else
        echo "Error: unknown version $2"
        usage
        exit 1
      fi
      shift
      shift
      ;;
    --arch | -a)
      if [[ " ${ARCH_LIST[@]} " =~ " ${2} " ]]; then
        GCC_TARGET_ARCH="$2"
      elif [ -z "$2" ]; then
        GCC_TARGET_ARCH=""
      else
        echo "Error: unknown arch $2"
        usage
        exit 1
      fi
      shift
      shift
      ;;
    *) ;;
    esac
  done

  if [ -z "$GCC_TARGET_VERSION" ]; then
    GCC_VERSION_SUFFIX=""
  else
    GCC_VERSION_SUFFIX="-$GCC_TARGET_VERSION"
  fi

  if [ -z "$GCC_TARGET_ARCH" ]; then
    GCC_ARCH_SUFFIX=""
  elif [ "$GCC_TARGET_ARCH" == "$ARCH" ]; then
    GCC_ARCH_SUFFIX=""
  else
    # Replace _ with - in GCC_TARGET_ARCH
    GCC_ARCH_SUFFIX="-${GCC_TARGET_ARCH//_/-}-linux-gnu"
  fi
}

function usage() {
  echo "Usage: $0 [options]"
  echo "options:"
  echo "  --arch, -a: target architecture, available: $GCC_ARCH_AVAILABLE"
  echo "  --version, -v: GCC version, available: $GCC_VERSION_AVAILABLE"
  echo "  --help, -h: display this help and exit"
  echo "Example: $0 -a x86_64 -v 9"
}

function install_gcc() {
  apt_update_cmd="sudo apt update"
  apt_install_cmd="sudo apt install gcc$GCC_VERSION_SUFFIX$GCC_ARCH_SUFFIX g++$GCC_VERSION_SUFFIX$GCC_ARCH_SUFFIX"
  echo $apt_update_cmd
  echo $apt_install_cmd
  $apt_update_cmd
  $apt_install_cmd
}

function main() {
  parse_available_versions
  parse_available_arch
  parse_params "$@"
  check_result install_gcc
}

main "$@"
