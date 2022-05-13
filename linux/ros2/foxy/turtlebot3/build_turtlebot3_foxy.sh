#!/bin/bash
BASEDIR=$(dirname "$0")
ROS2_DIR=~/ros2_foxy
TB3_ROS2_WS_DIR=~/tb3_foxy_ws2
TB3_REPOS_FILE_NAME=turtlebot3_foxy.repos
TB3_REPOS_FILE_PATH=$BASEDIR/$TB3_REPOS_FILE_NAME
TB3_BUILD_SCRIPT_FILE_NAME=$(basename "$0")

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

function get_tb3_ros2()
{
  mkdir -p $TB3_ROS2_WS_DIR/src
  cp $TB3_REPOS_FILE_PATH $TB3_ROS2_WS_DIR
  cp $BASEDIR/*.sh $TB3_ROS2_WS_DIR
  cd $TB3_ROS2_WS_DIR
  vcs import src < $TB3_REPOS_FILE_NAME
}

function build_tb3_ros2()
{
  cd $TB3_ROS2_WS_DIR
  source $ROS2_DIR/install/local_setup.bash
  colcon build --symlink-install
}

function main()
{
  check_result get_tb3_ros2
  check_result build_tb3_ros2
}

main
