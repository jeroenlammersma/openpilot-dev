#!/bin/bash

function validate_carla_env() {
  if [ -z "$CARLA_ENV" ]; then
    printf "%s\n%s\n" "CARLA environment not set up yet, run the setup first." "Abort." >&2
    exit 1
  fi
}

function validate_scenario_runner_root() {
  validate_carla_env

  if [ -z "$SCENARIO_RUNNER_ROOT" ]; then
    echo "SCENARIO_RUNNER_ROOT not specified" >&2
    exit 1
  fi

  if [ ! -d "$SCENARIO_RUNNER_ROOT" ]; then
    echo "Directory does not exist: $SCENARIO_RUNNER_ROOT" >&2
    exit 1
  fi
}
