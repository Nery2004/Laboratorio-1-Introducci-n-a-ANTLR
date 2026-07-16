#!/bin/sh
set -eu

VENV_PATH="${VENV_PATH:-/opt/venv}"

python3 -m venv "$VENV_PATH"
. "$VENV_PATH/bin/activate"

if [ "$#" -gt 0 ]; then
    exec "$@"
fi
