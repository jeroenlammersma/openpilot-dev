#!/bin/bash

set -e

# function egress() {
#   if command -v "wmctrl" > /dev/null 2>&1; then
#     wmctrl -r ':ACTIVE:' -b remove,fullscreen
#   fi
# }
# trap egress EXIT

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
ROOT="$(cd "$DIR"/../ && pwd)"
source "$ROOT/setup/openpilot/helpers.sh"
validate_openpilot_path


# wmctrl -r ':ACTIVE:' -b add,fullscreen

export PIPENV_PIPFILE="$OPENPILOT_PATH/Pipfile"
cd "$OPENPILOT_PATH/tools/sim"
pipenv run ./launch_openpilot.sh
