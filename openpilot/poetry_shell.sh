#!/bin/bash
# Just an easy way to open a poetry shell in the openpilot project

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
ROOT="$(cd "$DIR"/../ && pwd)"
source "$ROOT/setup/openpilot/helpers.sh"
validate_openpilot_path


cd "$OPENPILOT_PATH"
poetry shell
