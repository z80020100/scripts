#!/bin/bash

BASEDIR=$(dirname "$0")
TB3_ENV_SETUP_FILE_PATH=$BASEDIR/envsetup.sh

source $TB3_ENV_SETUP_FILE_PATH

MAP_DIR=$TB3_ROS2_WS_DIR/map
MAP_YAML_NAME=turtlebot3_world.yaml
MAP_YAML_PATH=$MAP_DIR/$MAP_YAML_NAME

function main()
{
  ros2 launch turtlebot3_navigation2 navigation2.launch.py use_sim_time:=True map:=$MAP_YAML_PATH
}

main
