#!/bin/bash
MAP=${1:-$(dirname "$0")/../maps/map.yaml}
ros2 launch turtlebot4_navigation localization.launch.py use_sim_time:=true map:=$(realpath $MAP)
