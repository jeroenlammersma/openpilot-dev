#!/bin/bash
# Just an easy way to open a pipenv shell in the openpilot project

# DELETE FILE IF OPENPILOT UPDATED TO USE POETRY

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
ROOT="$(cd "$DIR"/../ && pwd)"
source "$ROOT/setup/openpilot/helpers.sh"
validate_openpilot_path


cd "$OPENPILOT_PATH"
pipenv shell
