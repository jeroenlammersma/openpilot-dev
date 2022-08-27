#!/bin/bash

function validate_openpilot_dev_env() {
  if [ -z "$OPENPILOT_DEV_ENV" ]; then
    printf "%s\n%s\n" "openpilot-dev environment not set up yet, run the setup first." "Abort." >&2
    exit 1
  fi
}

function validate_openpilot_path() {
  validate_openpilot_dev_env

  if [ -z "$OPENPILOT_PATH" ]; then
    echo "OPENPILOT_PATH not specified" >&2
    exit 1
  fi

  if [ ! -d "$OPENPILOT_PATH" ]; then
    echo "Directory does not exist: $OPENPILOT_PATH" >&2
    exit 1
  fi
}

function validate_openpilot_logs_path() {
  validate_openpilot_dev_env

  if [ -z "$OPENPILOT_LOGS_PATH" ]; then
    echo "OPENPILOT_LOGS_PATH not specified" >&2
    exit 1
  fi

  if [ ! -d "$OPENPILOT_LOGS_PATH" ]; then
    echo "Directory does not exist: $OPENPILOT_LOGS_PATH" >&2
    exit 1
  fi
}
