#!/bin/bash

DEFAULT_SIZE="60.945G"
DEFAULT_LV_NAME="/dev/ubuntu-vg/ubuntu-lv"
TARGET_SIZE=${1:-$DEFAULT_SIZE}
LV_PATH=${2:-$DEFAULT_LV_NAME}

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

function display_lvm() {
  sudo pvdisplay
  sudo vgdisplay
  sudo lvdisplay
}

function extend_logical_volume() {
  sudo lvextend -L $TARGET_SIZE $LV_PATH
  sudo resize2fs $LV_PATH
}

function main() {
  check_result display_lvm
  check_result extend_logical_volume
}

main
