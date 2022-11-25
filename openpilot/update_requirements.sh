#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
ROOT="$(cd "$DIR"/../ && pwd)"
source "$ROOT/setup/openpilot/helpers.sh"
validate_openpilot_path


export PIPENV_PIPFILE="$OPENPILOT_PATH/Pipfile" # REMOVE IF OPENPILOT UPDATED TO USE POETRY
cd "$OPENPILOT_PATH"
# poetry run ./update_requirements.sh           # UNCOMMENT IF OPENPILOT UPDATED TO USE POETRY
pipenv run ./update_requirements.sh             # REMOVE IF OPENPILOT UPDATED TO USE POETRY
