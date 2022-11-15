#!/bin/bash

if [ -z "$OPENPILOT_DEV_ENV" ]; then

  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
  if ! source "$DIR/.openpilot_dev_env1.sh" &> /dev/null; then
    export OPENPILOT_PATH="$HOME/openpilot"
    export OPENPILOT_DEV_PATH="$HOME/openpilot-dev"
  fi

  export OPENPILOT_LOGS_PATH="$HOME/.comma/media/0/realdata"
  export OPENPILOT_DEV_ENV=1

  if [ -z "$OPENPILOT_ENV" ]; then
    export PATH="$HOME/.pyenv/bin:$PATH"

    # Pyenv suggests we place the below two lines in .profile before we source
    # .bashrc, but there is no simple way to guarantee we do this correctly
    # programmatically across heterogeneous systems. For end-user convenience,
    # we add the lines here as a workaround.
    # https://github.com/pyenv/pyenv/issues/1906
    export PYENV_ROOT="$HOME/.pyenv"

    if [[ "$(uname)" == 'Linux' ]]; then
      eval "$(pyenv virtualenv-init -)"
    elif [[ "$(uname)" == 'Darwin' ]]; then
      # msgq doesn't work on mac
      export ZMQ=1
      export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
    fi
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
  fi

fi
