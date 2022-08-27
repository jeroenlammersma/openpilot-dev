#!/bin/bash
# TODO: exec command + keep terminals open after stopping command
# TODO: snap terminals in corners

set -e


# [bottom left] Start CARLA (render off screen)
cd "$OPENPILOT_DEV_PATH/carla"
# gnome-terminal -- ./start_carla.sh
gnome-terminal

# [top right] start bridge
cd "$OPENPILOT_DEV_PATH/openpilot"
# gnome-terminal -- ./bridge.py
# gnome-terminal --geometry 101x20+996+0 --
gnome-terminal

# [bottom right] Scenario Runner
cd "$OPENPILOT_DEV_PATH/carla"
gnome-terminal

# [top left] launch openpilot
cd "$OPENPILOT_DEV_PATH/openpilot"; clear; bash;
# gnome-terminal -- ./launch_openpilot.sh
# gnome-terminal --geometry 100x20+0+0 --
