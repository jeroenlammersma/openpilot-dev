#!/bin/bash

print_title "DEVELOPMENT TOOLS"

print_start "Installing Vim"
source "$SETUP_DIR/tools/vim.sh"
setup_vim
print_done

print_start "Installing Docker"
source "$SETUP_DIR/tools/docker.sh"
setup_docker
print_done

print_start "Installing VS Code"
source "$SETUP_DIR/tools/vscode.sh"
setup_vscode
print_done

print_start "Installing GitHub CLI"
source "$SETUP_DIR/tools/gh.sh"
setup_gh
print_done
