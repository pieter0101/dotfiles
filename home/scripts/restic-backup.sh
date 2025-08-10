#!/usr/bin/env bash

# RSYNC_CMD="rsync -avzchP --ignore-existing --delete --prune-empty-dirs --exclude \"Mounts/*\" --exclude \".cache\" $HOME PieterKnNAS@100.72.131.77:~/backup"

if [[ $(uname) =~ Darwin ]]; then
    export DARWIN=true
    export RESTIC_REPOSITORY=/Volumes/pieter/backup/restic/$HOSTNAME
else
    export RESTIC_REPOSITORY=$HOME/mounts/synology/backup/restic/$HOSTNAME
fi
export RESTIC_PASSWORD_FILE=$HOME/.resticpw-$HOSTNAME

if [ -e "$HOME"/.resticpw-"$HOSTNAME" ]; then
    echo "Password file found"
else
    echo "No password file found, creating one now"
    openssl rand -base64 100 >"$HOME"/.resticpw-"$HOSTNAME"
fi

if [ -e "$RESTIC_REPOSITORY"/config ]; then
    echo "Repository found"
else
    echo "Repository not found, creating one now"
    restic init --repo "$RESTIC_REPOSITORY"
fi

echo "Starting backup"

echo "Unlocking repo"
restic unlock

echo "Starting incremental backup"
if [[ $DARWIN ]]; then
    restic --verbose backup "$HOME" --skip-if-unchanged --exclude-file="$HOME/.restic_ignore"
else
    restic --verbose backup / --skip-if-unchanged --exclude-file="$HOME/.restic_ignore"
    [ $? -ne 0 ] && notify-send "Error occured during restic backup"
fi

echo "Getting rid of older snapshots"
restic forget --keep-daily 7 --keep-weekly 5 --keep-monthly 12 --keep-yearly 75

echo "Verifying subset of backup integrity"
restic check --read-data-subset "$(date +%d)"/"$(cal | awk 'FNR>2{d+=NF}END{print d}')"
[ $? -ne 0 ] && notify-send "Error occured reading subset of data"

if [ "$(date +%u)" = 1 ]; then
    echo "Performing a monthly check"
    restic check
    [ $? -ne 0 ] && notify-send "Error occured during restic check"
fi

echo "Backup complete"
