#!/bin/bash
# TODO: abort if segment does not exist
# TODO: add getopt & usage
# TODO: --log-type flag to specify --qlog or --rlog (rlog default)

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
ROOT="$(cd "$DIR"/../ && pwd)"
source "$ROOT/setup/openpilot/helpers.sh"
validate_openpilot_logs_path


re="^[[:digit:]]{4}-"  # first 4 chars need to be digits, followed by a hyphen

latest_path=$(cut -d " " -f 1 <<< $(echo $OPENPILOT_LOGS_PATH/*/))
latest_path=$(readlink -m "$latest_path")
latest_basename=$(basename "$latest_path")

if [[ $latest_basename =~ $re ]]; then
  segment=${1:-0}
  export PIPENV_PIPFILE="$OPENPILOT_PATH/Pipfile"
  pipenv run python "$OPENPILOT_PATH"/tools/plotjuggler/juggle.py "${latest_path%"--"*}--$segment/rlog"
else
  echo "No logs found." >&2
  exit 1
fi
