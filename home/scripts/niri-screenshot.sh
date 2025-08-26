#!/usr/bin/env bash

# `niri msg action screenshot` returns when the screenshot utility is opened, not when a screenshot has been taken.
# This script is a workaround.

SECONDS=0
MAX_WAIT=15
DEPENDENCIES=(
    niri
    wl-paste
    sha256sum
    satty
)

RUNNABLE=true
for dependency in "${DEPENDENCIES[@]}"; do
    if command -v "$dependency" >/dev/null 2>&1; then
        echo "$dependency found"
    else
        echo "$dependency not found"
        RUNNABLE=false
    fi
done
# Wait to exit so there's no need to keep re-running the script if multiple dependencies are missing
if ! "$RUNNABLE"; then
    echo "Not all dependencies present, exiting..."
    exit 1
fi

initial_hash="$(wl-paste | sha256sum)"
niri msg action screenshot
while true; do
    if [[ "$SECONDS" -gt "$MAX_WAIT" ]]; then
        echo "Timeout, exiting..."
        exit 1
    fi
    current_hash="$(wl-paste | sha256sum)"
    if [[ "$current_hash" != "$initial_hash" ]]; then
        break
    fi
    sleep 0.1
done
wl-paste | satty --filename -
