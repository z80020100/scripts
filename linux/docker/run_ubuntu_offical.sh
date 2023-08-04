#!/bin/bash
# https://hub.docker.com/_/ubuntu

DEFAULT_VERSION="latest"
MOUNT_HOME_ARG="-v $HOME:/root"

function usage() {
  echo "Usage: $0 [version] [options]"
  echo "  version: Ubuntu version, default: $DEFAULT_VERSION"
  echo "  options: docker run options"
  echo "Example: $0 22.04 --mount=home --network=host"
}

function parse_params() {
  while [ "$1" ]; do
    case "$1" in
    --help | -h)
      usage
      exit 0
      ;;
    --mount=home)
      EXTRA_ARGS="$EXTRA_ARGS $MOUNT_HOME_ARG"
      shift
      ;;
    -*)
      EXTRA_ARGS="$EXTRA_ARGS $@"
      break
      ;;
    *)
      if [ -z "$VERSION" ]; then
        VERSION=${1:-$DEFAULT_VERSION}
        shift
      else
        usage
        exit 1
      fi
      ;;
    esac
  done
}

function run() {
  docker run -it $EXTRA_ARGS ubuntu:$VERSION /bin/bash
}

function main() {
  parse_params "$@"
  run
}

main "$@"
