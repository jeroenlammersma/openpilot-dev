#!/bin/bash

if [ -z "$OPENPILOT_DEV_ENV" ]; then

  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
  if ! source "$DIR/.openpilot_dev_env1.sh" &> /dev/null; then
    export OPENPILOT_PATH="$HOME/openpilot"
    export OPENPILOT_DEV_PATH="$HOME/openpilot-dev"
  fi

  export OPENPILOT_LOGS_PATH="$HOME/.comma/media/0/realdata"
  export OPENPILOT_DEV_ENV=1
fi
