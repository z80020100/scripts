#!/bin/bash
BASEDIR=$(dirname "$0")
ROS2_DIR=~/ros2_galactic
TB3_ROS2_WS_DIR=~/tb3_galactic_ws2
TB3_REPOS_FILE_NAME=turtlebot3_galactic.repos
TB3_REPOS_FILE_PATH=$BASEDIR/$TB3_REPOS_FILE_NAME
TB3_BUILD_SCRIPT_FILE_NAME=$(basename "$0")
MAP_DIR=$TB3_ROS2_WS_DIR/map
NAV2_BUILDIN_MAPS_DIR=$TB3_ROS2_WS_DIR/src/ros-planning/navigation2/nav2_bringup/bringup/maps

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

function copy_maps()
{
  mkdir -p $MAP_DIR
  cp $NAV2_BUILDIN_MAPS_DIR/* $MAP_DIR
}

function build_tb3_ros2()
{
  cd $TB3_ROS2_WS_DIR
  source $ROS2_DIR/install/local_setup.bash
  colcon build --symlink-install
}

function main()
{
  create_resouces
  check_result get_tb3_ros2
  # check_result copy_maps
  check_result build_tb3_ros2
}

main
