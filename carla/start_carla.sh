#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
ROOT="$(cd "$DIR"/../ && pwd)"
source "$ROOT/setup/carla/helpers.sh"
validate_carla_env


"$CARLA_ROOT"/CarlaUE4.sh -RenderOffScreen "$@"
