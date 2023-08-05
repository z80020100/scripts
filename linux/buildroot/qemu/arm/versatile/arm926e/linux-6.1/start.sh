#!/bin/bash

SCRIPT_PATH=$(
  cd "$(dirname "$0")"
  pwd
)
START_QEMU_SCRIPT=$SCRIPT_PATH/images/start-qemu.sh

exec $START_QEMU_SCRIPT
