#!/bin/bash

function setup_carla() {
  obtain_sudo
  # add repository and install CARLA
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1AF1527DE64CB8D9
  sudo add-apt-repository "deb [arch=amd64] http://dist.carla.org/carla $(lsb_release -sc) main" > /dev/null
  sudo apt-get update > /dev/null && sudo apt-get install -y "carla-simulator=$CARLA_VERSION"
  
  #TODO: first download, obtain sudo, then  install
      # obtain_sudo
      # sudo apt-get install -y "carla-simulator=$CARLA_VERSION"

  # create symlink to CARLA
  ln -sfn "/opt/carla-simulator" "$ROOT/carla/carla-simulator"
  echo "Symlink created: $_"
  sleep 1

  # add carla env to .bashrc
  if [ -z "$CARLA_ENV" ]; then
    printf '\nsource %s' "$ROOT/carla/.carla_env.sh" >> ~/.bashrc
    echo "Added carla_env to bashrc"
    sleep 1
  fi
}

function setup_scenario_runner() {
  cd "$ROOT" && obtain_sudo
  SCENARIO_RUNNER_ROOT="$ROOT/carla/scenario_runner"
  git submodule status "$SCENARIO_RUNNER_ROOT"
  if [ ! -f "$SCENARIO_RUNNER_ROOT/.git" ]; then
    echo "Initialising submodule..."
    git submodule update --init --recursive "$SCENARIO_RUNNER_ROOT"
  fi
}


print_title "CARLA SIMULATOR"

# CARLA setup
print_start "Installing CARLA simulator ($CARLA_VERSION)"
setup_carla
print_done

# Scenario Runner setup
print_start "Setting up Scenario Runner ($CARLA_VERSION)"
setup_scenario_runner
print_done
