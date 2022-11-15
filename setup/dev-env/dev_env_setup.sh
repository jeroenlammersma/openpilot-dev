#!/bin/bash

function create_file() {
  touch "$1"
  echo '#!/bin/bash' >> "$1"
  cyanprint "$2"
}

function install_pyenv_dependencies() {
  echo "Installing dependencies needed for pyenv..."

  sudo apt-get install \
    build-essential \
    curl \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libxmlsec1-dev \
    llvm \
    make \
    tk-dev \
    wget \
    xz-utils \
    zlib1g-dev
}

function setup_poetry() {
  check_for_existing_pyenv_root
  install_pyenv_dependencies
  cd $OPENPILOT_DEV_PATH

  RC_FILE="${HOME}/.$(basename ${SHELL})rc"
  if [ "$(uname)" == "Darwin" ] && [ $SHELL == "/bin/bash" ]; then
    RC_FILE="$HOME/.bash_profile"
  fi

  if ! command -v "pyenv" > /dev/null 2>&1; then
    echo "pyenv install ..."
    curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

    echo -e "\n. ~/.pyenvrc" >> $RC_FILE
    cat <<EOF > "${HOME}/.pyenvrc"
if [ -z "\$PYENV_ROOT" ]; then
  export PATH=\$HOME/.pyenv/bin:\$HOME/.pyenv/shims:\$PATH
  export PYENV_ROOT="\$HOME/.pyenv"
  eval "\$(pyenv init -)"
  eval "\$(pyenv virtualenv-init -)"
fi
EOF
  fi
  source $RC_FILE

  export MAKEFLAGS="-j$(nproc)"

  PYENV_PYTHON_VERSION=$(cat .python-version)
  if ! pyenv prefix ${PYENV_PYTHON_VERSION} &> /dev/null; then
    # no pyenv update on mac
    if [ "$(uname)" == "Linux" ]; then
      echo "pyenv update ..."
      pyenv update
    fi
    echo "python ${PYENV_PYTHON_VERSION} install ..."
    CONFIGURE_OPTS="--enable-shared" pyenv install -f ${PYENV_PYTHON_VERSION}
  fi
  eval "$(pyenv init --path)"

  echo "update pip"
  pip install pip==22.3
  pip install poetry==1.2.2

  poetry config virtualenvs.prefer-active-python true --local

  POETRY_INSTALL_ARGS=""
  if [ -d "./xx" ]; then
    echo "WARNING: using xx dependency group, installing globally"
    poetry config virtualenvs.create false --local
    POETRY_INSTALL_ARGS="--with xx --sync"
  fi

  echo "pip packages install..."
  poetry install --no-cache --no-root $POETRY_INSTALL_ARGS
  pyenv rehash
}

function setup_dev_environment() {
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


print_title "OPENPILOT-DEV ENVIRONMENT"

# setup poetry
print_start "Setting up poetry"
if ! setup_poetry; then  # poetry setup exits if pyenv was not installed (now installed)
  source ~/.pyenvrc      # reload pyenvrc
  setup_poetry           # run poetry setup again to continue setup
fi
print_done

# setup openpilot-dev env
print_start "Setting up environment"
setup_dev_environment
print_done
