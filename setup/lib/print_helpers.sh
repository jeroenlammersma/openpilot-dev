#!/bin/bash

### Colors ##
ESC=$(printf '\033') RESET="${ESC}[0m" BLACK="${ESC}[30m" RED="${ESC}[31m"
GREEN="${ESC}[32m" YELLOW="${ESC}[33m" BLUE="${ESC}[34m" MAGENTA="${ESC}[35m"
CYAN="${ESC}[36m" WHITE="${ESC}[37m" DEFAULT="${ESC}[39m" DARKGREY="${ESC}[90m"
GREENBOLD="${ESC}[1;32m" BLUEBOLD="${ESC}[1;34m" WHITEBOLD="${ESC}[1;37m"
ITALIC="${ESC}[3m"

### Color Functions ##
greenprint() { printf "${GREEN}%s${RESET}\n" "$1"; }
greenboldprint() { printf "${GREENBOLD}%s${RESET}\n" "$1"; }
blueprint() { printf "${BLUE}%s${RESET}\n" "$1"; }
blueboldprint() { printf "${BLUEBOLD}%s${RESET}\n" "$1"; }
redprint() { printf "${RED}%s${RESET}\n" "$1"; }
yellowprint() { printf "${YELLOW}%s${RESET}\n" "$1"; }
magentaprint() { printf "${MAGENTA}%s${RESET}\n" "$1"; }
cyanprint() { printf "${CYAN}%s${RESET}\n" "$1"; }
whiteprint() { printf "${WHITE}%s${RESET}\n" "$1"; }
whiteboldprint() { printf "${WHITEBOLD}%s${RESET}\n" "$1"; }
darkgreyprint() { printf "${DARKGREY}%s${RESET}" "$1"; }
italicprint() { printf "${ITALIC}%s${RESET}" "$1"; }

### Header ##
HEADER="
H4sIAAAAAAAAA5VRQQrDMAy79xW+bYOy/KangPcQPX6W5JaWscFiahRZUtI24ufKqh2d2e/661rI
ZSooGxuq3/MREIlAezNhrg1xRGjiG+0plT8KTsSturEgule1gO6Q/NWcDMNcNuXTWQpcCviSUK/5
6LkJnASM5w4tnLEpPmYyy169w+FfNMyBeHJKvCtIgDsJOEJnreZQWPEl52mkpp+1/fr+VuD6Yz6I
P1f735GTPzs/AgAA"

### Print Functions ##
function print_usage() {
  printf "%s\n\n" "Set up your openpilot development environment in an easy manner."
  whiteboldprint "USAGE"
  printf "  %s\t\t%s\n" "setup.sh" "Start user-friendly interactive prompt."
  printf "  %s\t%s\n\n" "setup.sh [flags]" "Skip interactive prompt and start tasks provided by flags right away."
  whiteboldprint "FLAGS"
  printf "  %s\t\t\t%s\n" "--all" "Do a full setup of the openpilot development environment."
  printf "  %s\t\t%s\n" "--carla" "Setup CARLA simulator and Scenario Runner."
  printf "  %s\t\t%s\n" "--dev-env" "Set up openpilot development pipenv and some convenient scripts."
  printf "  %s\t%s\n" "--nvidia-driver" "Install recommended NVIDIA graphics driver."
  printf "  %s\t\t%s\n" "--openpilot" "Install and set up openpilot."
  printf "  %s\t\t%s\n" "--tools" "Install useful development tools."
  printf "  %s\t\t%s\n\n" "--help" "Show help for script."
}

function print_header() {
  local -r decoded=$(base64 -d <<< "$HEADER" | gunzip && echo)
  blueboldprint "$decoded";
  echo
  sleep 2
  echo
}

function nothing_to_do() {
  printf "%s" "Let's install..."; sleep 3
  printf "\r\033[K%s%s" "Let's install " "$(italicprint 'nothing')"
  sleep 2; printf "%s" " :)"; sleep 2; echo; sudo apt-get install nothing
}

function create_text_box() { # $txt
  local -r n=$((${#1} + 4))
  local -r ch="$(printf "%"$n"s" "")"

  local string
  string="┌${ch// /─}┐\n"
  string+="│  $1  │\n"
  string+="└${ch// /─}┘"
  echo -e "$string"
}

function print_title() { # $txt $sec=1
  blueprint "$(create_text_box "$1")"
  sleep "${2:-1}"
}

function print_footer() { # $n $sec=1
  if [ "$1" -gt 1 ]; then
    _tasks_text="$1 TASKS";
  else
    _tasks_text="TASK"
  fi
  greenprint "$(create_text_box "$_tasks_text COMPLETED")"
  sleep "${1:-1}"
}

function print_start() { # $txt $sec=1
  blueprint "> $1..."
  sleep "${2:-1}"
}

function print_done() { # $sec=1
  greenprint 'Done.'
  sleep "${1:-1}"; echo
}
