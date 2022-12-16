#!/bin/bash
# TODO: add getopt & better usage

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
ROOT="$(cd "$DIR"/../ && pwd)"
source "$ROOT/setup/carla/helpers.sh"
validate_scenario_runner_root


if [ -z "$1" ]; then
  echo -e "Abort. No scenario specified.\n"
  echo "usage: start_scenario.sh <scenario-name>"
  echo "example: start_scenario.sh FollowLeadingVehicle_1"
  exit 1
fi

if [ ! -f "$SCENARIO_RUNNER_ROOT/.git" ]; then
  echo "Need to initialize submodule first..."
  cd "$OPENPILOT_DEV_PATH" && git submodule update --init --recursive "$SCENARIO_RUNNER_ROOT"
fi


cd "$SCENARIO_RUNNER_ROOT"
scenario="$1"
shift

poetry run python scenario_runner.py --scenario "$scenario" --waitForEgo "$@"
