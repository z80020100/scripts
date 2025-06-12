#!/bin/bash
SCRIPT_DIR=$(dirname "$0")
source $SCRIPT_DIR/common.sh

MAP_DIR=$TB3_ROS2_WS_DIR/map
NAV2_BUILDIN_MAPS_DIR=$TB3_ROS2_WS_DIR/src/ros-planning/navigation2/nav2_bringup/bringup/maps

function copy_maps()
{
  mkdir -p $MAP_DIR
  cp $NAV2_BUILDIN_MAPS_DIR/* $MAP_DIR
}

function build_tb3_ros2()
{
  cd $TB3_ROS2_WS_DIR
  source $ROS2_DIR/install/local_setup.bash
  colcon build --merge-install
}

function main()
{
  # Setup environment if needed
  check_setup_status || check_result $SCRIPT_DIR/setup_env_turtlebot3_galactic.sh

  check_result copy_maps
  check_result build_tb3_ros2
}

main
