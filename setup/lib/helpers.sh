#!/bin/bash

_esc_code_choice="K"

### Options Functions ##
function request_choice() { # $message $variable
  local -r line="$(greenboldprint '?') $(whiteboldprint "$1")"
  read -p "$line $(darkgreyprint '(Y/n)') " -n 1 -r

  if [[ ! $REPLY =~ ^[YyNn]$ ]]; then
    local err="X Sorry, your reply was invalid: \"$REPLY\" is not a valid answer, please try again."
    printf "\r\033[%s%s\n" "$_esc_code_choice" "$(redprint "$err")"
    _esc_code_choice="1A"
    request_choice "$1"
    return $?
  fi

  _esc_code_choice="K"
  printf "\r\033[K%s " "$line"
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    greenprint "Yes"
    return 0
    elif [[ $REPLY =~ ^[Nn]$ ]]; then
    redprint No
    return 1
  else
    echo
    redprint 'Abort.' >&2
    exit 1
  fi
}

function request_setup_choices() {
  if request_choice "Setup openpilot?"; then
    DO_OPENPILOT_SETUP=1
  fi
  if request_choice "Install and setup CARLA simulator? (will also set up openpilot-dev poetry env)"; then
    DO_CARLA_SETUP=1
    DO_DEV_ENV_SETUP=1
    echo "$(greenboldprint '?') $(whiteboldprint 'Setup openpilot-dev poetry env?') $(greenprint Yes)"
  fi
  if [ -z "$DO_DEV_ENV_SETUP" ] && request_choice "Setup openpilot-dev poetry env?"; then
    DO_DEV_ENV_SETUP=1
  fi
  if request_choice "Install development tools?"; then
    DO_DEV_TOOLS_INSTALL=1
  fi

  if request_choice "Install recommended NVIDIA graphics driver?"; then
    DO_NVIDIA_GRAPHICS=1
  fi
}

function full_setup() {
  DO_OPENPILOT_SETUP=1
  DO_DEV_ENV_SETUP=1
  DO_DEV_TOOLS_INSTALL=1
  DO_CARLA_SETUP=1
  DO_NVIDIA_GRAPHICS=1
}

function request_full_setup() {
  if request_choice "Do you want to do a full setup? (recommended)"; then
    full_setup
  fi
}

### Other Functions ##
function check_default_openpilot_path() {
  if [ "$OPENPILOT_PATH" != "$HOME/openpilot" ]; then
    redprint 'WARNING! not using default openpilot path'
    echo "This may cause side-effects and errors in the environment which require manual fixing."
    echo "It is recommended to use the default path: $HOME/openpilot"
    if request_choice "Use default path?"; then
      OPENPILOT_ROOT=~
      OPENPILOT_PATH=$(readlink -m $OPENPILOT_ROOT/openpilot)
      cyanprint "Now using default openpilot path: $OPENPILOT_PATH"
    else
      yellowprint "Using non-default openpilot path: $OPENPILOT_PATH"
    fi
    sleep 1
    echo
  fi
}

function check_for_existing_pyenv_root() {
  if ! command -v "pyenv" > /dev/null 2>&1 && [ -d "$HOME/.pyenv" ]; then
    yellowprint "pyenv directory detected..."
    echo "$HOME/.pyenv"
    sleep 1
    rm -rf "$HOME/.pyenv"
    cyanprint "Directory deleted."
    sleep 1
    echo "Continuing setup..."
    sleep 1
  fi
}

function obtain_sudo() {
  sudo echo "hackish but works" > /dev/null
}

### Windows Subsystem for Linux
function is_wsl() {
  kernel=$(uname -r | tr '[:upper:]' '[:lower:]')
  if [[ $kernel == *"microsoft"* ]]; then
    return 0
  else
    return 1
  fi
}

function setup_wsl() {
  if is_wsl; then

    if [ -z "$WSL_ENV" ]; then
      yellowprint "WSL detected..." && sleep 1
      {
        printf "\n%s " "WSL_ENV=1"
        printf "\n%s " "# enable passphrase prompt for GPG"
        printf "\n%s" "export GPG_TTY=\$(tty)"
      } >> ~/.bashrc
      cyanprint "added wsl_env to bashrc"
      sleep 1

      local -r gpg_conf="$HOME/.gnupg/gpg-agent.conf"
      mkdir -p "$HOME/.gnupg"
      if [ ! -f "$gpg_conf" ]; then
        touch "$gpg_conf"
        {
          printf "%s" "default-cache-ttl 28800"
          printf "\n%s" "max-cache-ttl 28800"
        } >> "$gpg_conf"
        cyanprint "created config for gpg agent: $gpg_conf"
        sleep 1
      fi
    fi

    WSL_ENV=1
  fi
}
