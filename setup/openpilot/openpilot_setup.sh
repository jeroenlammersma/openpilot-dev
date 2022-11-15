#!/bin/bash

print_title "OPENPILOT"

# clone repository
print_start "Setting up $OPENPILOT_REPO_OWNER/$OPENPILOT_REPO_NAME repository"
if [ ! -d "$OPENPILOT_PATH" ]
then
  git clone "https://github.com/$OPENPILOT_REPO_OWNER/$OPENPILOT_REPO_NAME.git" "$OPENPILOT_PATH" \
            --recurse-submodules -j"$(nproc)" \
            ${OPENPILOT_REPO_BRANCH:+--branch "$OPENPILOT_REPO_BRANCH"}
else
  echo "Pulling latest changes..."
  if ! git -C "$OPENPILOT_PATH" pull; then
    printf "%s\n%s\n" "$OPENPILOT_PATH not empty and not a repo." "$(redprint 'Abort.')" >&2
    exit 1;
  fi
fi
print_done

# setup openpilot environment
print_start "Setting up openpilot environment"
obtain_sudo

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

cd "$OPENPILOT_PATH"
if ! tools/ubuntu_setup.sh; then  # ubuntu setup exits if pyenv was not installed (now installed)
  source ~/.pyenvrc               # reload pyenvrc
  cd "$OPENPILOT_PATH"
  tools/ubuntu_setup.sh           # run ubuntu setup again to continue setup
fi
print_done

# build openpilot
obtain_sudo
print_start "Building openpilot"
cd "$OPENPILOT_PATH"
poetry run scons -j"$(nproc)"
print_done

# install plotjuggler
print_start "Installing plotjuggler"
poetry run tools/plotjuggler/juggle.py --install
print_done

# create symlink to openpilot logs
print_start "Creating symlink to openpilot logs"
mkdir -p "$HOME/.comma/media/0/realdata"
ln -sfn "$_" "$ROOT/logs/realdata"
echo "Symlink created: $_"
print_done
