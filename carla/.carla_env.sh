#!/bin/bash

if [ -z "$CARLA_ENV" ]; then
  if [ -n "$OPENPILOT_DEV_PATH" ]; then
    export SCENARIO_RUNNER_ROOT=${OPENPILOT_DEV_PATH}/carla/scenario_runner
  fi

  export CARLA_ROOT=/opt/carla-simulator
  export PYTHONPATH=$PYTHONPATH:${CARLA_ROOT}/PythonAPI/carla/dist/carla-3.8.egg:${CARLA_ROOT}/PythonAPI/carla/agents:${CARLA_ROOT}/PythonAPI/carla
  export CARLA_ENV=1
fi
