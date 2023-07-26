#!/bin/bash

SOURCE_IMAGE=${1}
TARGET_MOUNT_POINT=${2}

function usage() {
  echo "Usage: $0 <source image> <target mount point>"
  exit 1
}

function check_args() {
  if [ -z "$SOURCE_IMAGE" ]; then
    echo "Error: source image is not specified"
    usage
  fi

  if [ -z "$TARGET_MOUNT_POINT" ]; then
    echo "Error: target mount point is not specified"
    usage
  fi

  if [ ! -f "$SOURCE_IMAGE" ]; then
    echo "Error: source image $SOURCE_IMAGE does not exist"
    usage
  fi

  mkdir -p $TARGET_MOUNT_POINT
  if [ ! -d "$TARGET_MOUNT_POINT" ]; then
    echo "Error: target mount point $TARGET_MOUNT_POINT does not exist"
    usage
  fi
}

function init_driver() {
  sudo modprobe mtdblock
  sudo modprobe mtdram
}

function mount_image() {
  sudo dd if=$SOURCE_IMAGE of=/dev/mtdblock0
  sudo mount -t jffs2 /dev/mtdblock0 $TARGET_MOUNT_POINT
}

function main() {
  check_args
  init_driver
  mount_image
}

main
