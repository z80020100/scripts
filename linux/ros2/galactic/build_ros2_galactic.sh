#!/bin/bash
BASEDIR=$(dirname "$0")
ROS2_DIR=~/ros2_galactic
ROS2_REPOS_FILE_NAME=ros2_galactic.repos
ROS2_REPOS_FILE_PATH=$BASEDIR/$ROS2_REPOS_FILE_NAME
ROS2_SCRIPT_FILE_NAME=$(basename "$0")
ROS2_SCRIPT_FILE_PATH=$BASEDIR/$ROS2_SCRIPT_FILE_NAME

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

function get_ros2()
{
  mkdir -p $ROS2_DIR/src
  cp $ROS2_REPOS_FILE_PATH $ROS2_DIR
  cp $ROS2_SCRIPT_FILE_PATH $ROS2_DIR
  cd $ROS2_DIR
  vcs import src < $ROS2_REPOS_FILE_NAME
}

function build_ros2()
{
  cd $ROS2_DIR
  colcon build --merge-install
}

function main()
{
  check_result get_ros2
  check_result build_ros2
}

main
