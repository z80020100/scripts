#!/bin/bash

ROS2_DIR=~/ros2_galactic

function check_result()
{
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

function build_ros2()
{
  cd $ROS2_DIR
  colcon build --merge-install
}

function main()
{
  check_result build_ros2
}

main
