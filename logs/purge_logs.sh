#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
ROOT="$(cd "$DIR"/../ && pwd)"
source "$ROOT/setup/lib/helpers.sh"
source "$ROOT/setup/lib/print_helpers.sh"
source "$ROOT/setup/openpilot/helpers.sh"
validate_openpilot_logs_path


redprint "You are about to delete all openpilot logs."
if ! request_choice "Are you sure?"; then
  echo "Abort." >&2
  exit 1
fi

re="^[[:digit:]]{4}-"  # first 4 chars need to be digits, followed by a hyphen

_n_logs=0
for dir in "$OPENPILOT_LOGS_PATH"/*/; do
  if [[ $(basename "$dir") =~ $re ]]; then
    ((_n_logs+=1))
    rm -rf "$dir"
  fi
done

printf "%s%s%s%s\n" "$_n_logs logfile" "$([ $_n_logs -eq 1 ] && echo "" || echo "s") " "deleted." \
                    " $([ $_n_logs  -eq 0 ] && echo "Logs directory was already empty." || echo "")"
