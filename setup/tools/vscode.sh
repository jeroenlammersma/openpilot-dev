#!/bin/bash

function setup_vscode() {
  if command -v "code" > /dev/null 2>&1; then
    echo "VS Code already installed"
    return
  fi

  sudo apt-get install -y wget gpg apt-transport-https > /dev/null
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  rm -f packages.microsoft.gpg
  sudo apt-get update && sudo apt-get -y install code
}
