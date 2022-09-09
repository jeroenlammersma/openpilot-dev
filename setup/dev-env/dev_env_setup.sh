#!/bin/bash

function create_file() {
  touch "$1"
  echo '#!/bin/bash' >> "$1"
  cyanprint "$2"
}

function setup_dev_environment() {
  sudo apt-get install pipenv -y


  local -r env1="$ROOT/openpilot/.openpilot_dev_env1.sh"

  if [ -f "$env1" ]; then
    yellowprint "Custom openpilot-dev environment detected..."
    sleep 1
    rm -f "$env1"
    cyanprint "$env1 deleted."
    sleep 1
    echo "Continuing setup..."
    sleep 1
  fi

  # replace OPENPILOT_PATH variable if not using default path
  local -r openpilot_path=$(readlink -m "$OPENPILOT_PATH")
  if [ "$openpilot_path" != "$HOME/openpilot" ]; then
    yellowprint 'Not using default openpilot path!'
    sleep 1
    if [ ! -f "$env1" ]; then
      create_file "$env1" "Created alternative env file: $env1"
    fi
    printf "\n%s" "OPENPILOT_PATH=$OPENPILOT_PATH" >> "$env1"
    cyanprint "Added alternative openpilot path: $OPENPILOT_PATH"
    sleep 1
  fi

  # replace OPENPILOT_DEV_PATH variable if not using default path
  local -r openpilot_dev_path=$(readlink -m "$ROOT")
  if [ "$openpilot_dev_path" != "$HOME/openpilot-dev" ]; then
    yellowprint "Not using default openpilot-dev path!"
    sleep 1
    if [ ! -f "$env1" ]; then
      create_file "$env1" "Created alternative env file: $env1"
    fi
    printf "\n%s" "OPENPILOT_DEV_PATH=$OPENPILOT_DEV_PATH" >> "$env1"
    cyanprint "Added alternative openpilot-dev path: $OPENPILOT_DEV_PATH"
    sleep 1
  fi

  # add openpilot dev env to .bashrc
  if [ -z "$OPENPILOT_DEV_ENV" ]; then
    printf '\n%s' "source $ROOT/openpilot/.openpilot_dev_env.sh" >> ~/.bashrc
    echo "Added openpilot_dev_env to bashrc"
    sleep 1
  fi
}

function setup_pipenv() {
  # ensure pip is working correctly by re-installing it
  echo "Configuring pip..."
  # curl -s https://bootstrap.pypa.io/get-pip.py -o "$scratch/get-pip.py"
  # cd "$ROOT" && pipenv run python3 "$scratch/get-pip.py" > /dev/null

  pipenv run "pip install --upgrade pip"
  pipenv run "pip install --upgrade setuptools"

  echo "Installing pip packages..."
  pipenv install --dev
}


print_title "OPENPILOT-DEV ENVIRONMENT"

# setup openpilot-dev env
print_start "Setting up environment"
setup_dev_environment
print_done

# setup pipenv
print_start "Setting up pipenv"
setup_pipenv
print_done
