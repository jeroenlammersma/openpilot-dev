#!/bin/bash

set -e

# abort if not using bash
if ! ps -hp "$$" | grep -q "bash"; then
  printf "Not using bash.\nAbort.\n" >&2
  exit 1
fi


function egress() {
  rm -rf "$scratch"
  if command -v "wmctrl" > /dev/null 2>&1; then
    wmctrl -r ':ACTIVE:' -b remove,fullscreen
  fi
}

# create scratch dir
scratch=$(mktemp -d -t tmp.XXXXXXXXXX)

# call egress on exit
trap egress EXIT

SETUP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
ROOT="$(cd "$SETUP_DIR"/../ && pwd)"

# load default config
source "$SETUP_DIR/config.defaults"
# load custom config, if exists
if [ -f "$SETUP_DIR/config" ]; then source "$SETUP_DIR/config"; fi
# load helpers
source "$SETUP_DIR/lib/print_helpers.sh"
source "$SETUP_DIR/lib/helpers.sh"

# set setup and paths
OPENPILOT_SETUP=1
OPENPILOT_PATH=$(readlink -m "$OPENPILOT_ROOT/openpilot")
OPENPILOT_DEV_PATH=$(readlink -m "$ROOT")


# parse flags
if ! OPT=$(getopt -o acdnoth --long all,carla,dev-env,nvidia-driver,openpilot,tools,help,test-mode \
                  -n 'setup.sh' -- "$@"); then echo "Abort." >&2 ; exit 1 ; fi
eval set -- "$OPT"
n_args=$(("$#" - 1))

while true; do
  case "$1" in
    -a | --all ) full_setup; shift ;;
    -c | --carla ) DO_CARLA_SETUP=1 DO_DEV_ENV_SETUP=1; shift ;;
    -d | --dev-env ) DO_DEV_ENV_SETUP=1; shift ;;
    -n | --nvidia-driver ) DO_NVIDIA_GRAPHICS=1; shift ;;
    -o | --openpilot ) DO_OPENPILOT_SETUP=1; shift ;;
    -t | --tools ) DO_DEV_TOOLS_INSTALL=1; shift ;;
    -h | --help ) print_usage; exit 0 ;;
    --test-mode ) TEST_MODE=1; shift ;;
    --)  if [ $# -eq 1 ]; then break; else shift; fi ;;
    * ) printf "%s\n%s\n" "setup.sh takes no arguments" \
        "Try 'bash setup.sh --help' for more information." >&2; exit 1 ;;
  esac
done


obtain_sudo
# set fullscreen, if possible
if [ -z "$TEST_MODE" ] && ! is_wsl; then
  if command -v "wmctrl" > /dev/null 2>&1 || sudo apt-get install wmctrl > /dev/null 2>&1; then
    wmctrl -r ':ACTIVE:' -b add,fullscreen
  fi
fi

# clear screen if possible
clear 2> /dev/null || :

print_header
check_default_openpilot_path

# request setup options if no flags given
if [ $n_args -eq 0 ]; then
  echo "You can run the full setup or choose which tasks to perform manually."
  if request_choice "Do you want to run the full setup? (recommended)"; then
    full_setup
  else
    printf "\n%s\n" "Please choose which tasks to perform:"
    request_setup_choices
  fi
  echo
fi

if [ -z "$DO_CARLA_SETUP" ] && [ -z "$DO_DEV_ENV_SETUP" ] && [ -z "$DO_NVIDIA_GRAPHICS" ] \
  && [ -z "$DO_OPENPILOT_SETUP" ] && [ -z "$DO_DEV_TOOLS_INSTALL" ]
then nothing_to_do; fi

# setup environment for WSL
if is_wsl; then setup_wsl; fi

# install packages
print_start "Update, upgrade and install packages"
sudo apt-get update
if [ -z "$TEST_MODE" ]; then
  sudo apt-get upgrade -y
fi
sudo apt-get install -y curl git scons
print_done 1


# start tasks
_n_tasks=0

# install dev tools
if [ -n "$DO_DEV_TOOLS_INSTALL" ]; then
  source "$SETUP_DIR/tools/tools_install.sh"
  ((_n_tasks+=1))
fi

# setup openpilot
if [ -n "$DO_OPENPILOT_SETUP" ]; then
  source "$SETUP_DIR/openpilot/openpilot_setup.sh"
  ((_n_tasks+=1))
fi

# setup dev env
if [ -n "$DO_DEV_ENV_SETUP" ]; then
  source "$SETUP_DIR/dev-env/dev_env_setup.sh"
  ((_n_tasks+=1))
fi

# setup CARLA
if [ -n "$DO_CARLA_SETUP" ]; then
  source "$SETUP_DIR/carla/carla_setup.sh"
  ((_n_tasks+=1))
fi

# autoinstall recommended graphics driver
if [ -n "$DO_NVIDIA_GRAPHICS" ]; then
  print_start "Installing recommended NVIDIA graphics driver"
  source "$SETUP_DIR/drivers/nvidia-graphics/autoinstall-recommended.sh"
  print_done
  ((_n_tasks+=1))
fi


# finish up
sudo apt-get autoremove -y > /dev/null
print_footer "$_n_tasks"

if [ -z "$TEST_MODE" ] && [ -z "$WSL_ENV" ] && [ -n "$DID_NVIDIA_INSTALL" ]; then
  printf "\n%s\n" "Please restart your machine to initialize NVIDIA graphics correctly."
  if request_choice "Do you want to reboot now? (recommended)"; then
    echo "REBOOTING NOW"; sleep 1
    reboot
  fi
fi

if [ -n "$DO_OPENPILOT_SETUP" ] || [ -n "$DO_DEV_ENV_SETUP" ]; then
  sleep 1
  printf "\n%s\n" "Open a new shell or configure your active shell env by running:"
  cyanprint "source ~/.bashrc"
fi

if [ -n "$NOT_IN_DOCKER_GROUP" ]; then
  sleep 1
  printf "\n%s\n" "User '$USER' added to the 'docker' group."
  echo "To use docker now, log out and log back in so that your group membership is re-evaluated."
fi
