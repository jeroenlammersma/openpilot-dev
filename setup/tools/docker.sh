#!/bin/bash

function setup_docker() {
  if command -v "docker" > /dev/null 2>&1; then
    echo "docker already installed"
  else
    sudo apt-get install -y runc containerd docker.io
  fi

  if command -v "nvidia-docker" > /dev/null 2>&1; then
    echo "nvidia-docker already installed"
  else
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
    curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
    sudo apt-get update && sudo apt-get install -y nvidia-docker2 # Also installs docker-ce and nvidia-container-toolkit

    if [ -z "$WSL_ENV" ]; then
      sudo systemctl restart docker
    fi
  fi

  # create docker group and add user to it
  [ "$(getent group docker)" ] || sudo groupadd "docker"
  if ! id -nG "$USER" | grep -qw "docker"; then
    NOT_IN_DOCKER_GROUP=1
    sudo usermod -aG docker "$USER"
    echo "Added $USER to docker group."
  fi
}
