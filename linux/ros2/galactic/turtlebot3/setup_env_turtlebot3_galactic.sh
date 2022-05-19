#!/bin/bash
BASEDIR=$(dirname "$0")
ROS2_DIR=~/ros2_galactic
TB3_ROS2_WS_DIR=~/tb3_galactic_ws2
TB3_REPOS_FILE_NAME=turtlebot3_galactic.repos
TB3_REPOS_FILE_PATH=$BASEDIR/$TB3_REPOS_FILE_NAME

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

function create_resouces()
{
  mkdir -p $TB3_ROS2_WS_DIR/src
  cp $TB3_REPOS_FILE_PATH $TB3_ROS2_WS_DIR
  cp $BASEDIR/*.sh $TB3_ROS2_WS_DIR
}

function get_tb3_ros2()
{
  cd $TB3_ROS2_WS_DIR
  vcs import src < $TB3_REPOS_FILE_NAME
}

function install_tb3_ros2_dependencies()
{
  cd $TB3_ROS2_WS_DIR
  rosdep install --from-paths src --ignore-src -r -y
}

function main()
{
  create_resouces
  check_result get_tb3_ros2
  check_result install_tb3_ros2_dependencies
}

main
