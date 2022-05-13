#!/bin/bash

BASEDIR=$(dirname "$0")
TB3_ENV_SETUP_FILE_PATH=$BASEDIR/envsetup.sh

source $TB3_ENV_SETUP_FILE_PATH

MAP_DIR=$TB3_ROS2_WS_DIR/map
MAP_NAME=map_$(date +'%Y%m%d_%H%M%S')
MAP_PATH=$MAP_DIR/$MAP_NAME

function main()
{
  mkdir -p $MAP_DIR
  ros2 run nav2_map_server map_saver_cli -f $MAP_PATH
}

main
