#!/usr/bin/env bash

SECONDS=0
MAX_WAIT=15
DEPENDENCIES=(
	niri
	satty
	wl-paste
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

niri msg action screenshot
niri msg --json event-stream | while read -r event; do
	if [[ "\"ScreenshotCaptured\"" == $(echo "$event" | jq '. | keys[]') ]]; then
		sleep 0.1
		wl-paste | satty --filename -
		break
	fi

	if [[ "$SECONDS" -gt "$MAX_WAIT" ]]; then
		echo "Timeout, exiting..."
		exit 1
	fi
done
