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

# create array and populate with log paths
logs=()
for path in "$OPENPILOT_LOGS_PATH"/*/; do
  path=$(readlink -m "$path")
  # only append log paths, skip other directories
  if [[ $(basename "$path") =~ $re ]]; then
    logs+=( "$path" )
  fi
done

# abort if array is empty
if [ -z "${logs[*]}" ]; then
  echo "No logs found, directory is empty. Abort." >&2
  exit 1
fi

# sort logs, descending order
IFS=$'\n' sorted_logs=($(sort -r <<<"${logs[*]}")); unset IFS

# get latest log
latest_log=${sorted_logs[0]}

# set segment (default is 0)
segment=${1:-0}

# open log with plotjuggler, trunc segment from path (--#) and concat $segment
poetry run python "$OPENPILOT_PATH"/tools/plotjuggler/juggle.py "${latest_log%"--"*}--$segment/rlog"
