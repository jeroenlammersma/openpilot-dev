#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
ROOT="$(cd "$DIR"/../ && pwd)"
source "$ROOT/setup/openpilot/helpers.sh"
validate_openpilot_path


export PIPENV_PIPFILE="$OPENPILOT_PATH/Pipfile" # REMOVE IF OPENPILOT UPDATED TO USE POETRY
cd "$OPENPILOT_PATH"
# poetry run scons -j"$(nproc)"                 # UNCOMMENT IF OPENPILOT UPDATED TO USE POETRY
pipenv run scons -j"$(nproc)"                   # REMOVE IF OPENPILOT UPDATED TO USE POETRY
