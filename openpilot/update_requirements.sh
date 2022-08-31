#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
ROOT="$(cd "$DIR"/../ && pwd)"
source "$ROOT/setup/openpilot/helpers.sh"
validate_openpilot_path


export PIPENV_PIPFILE="$OPENPILOT_PATH/Pipfile"
cd "$OPENPILOT_PATH"
pipenv run ./update_requirements.sh
