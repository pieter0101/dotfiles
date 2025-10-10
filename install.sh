#!/usr/bin/env bash

DOTFILESDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR=$(pwd)

echo "Stowing dotfiles..."

if ! command -v stow >/dev/null 2>&1; then
    echo "stow not found, exiting..."
    exit 1
fi

cd "$DOTFILESDIR" || exit 1
stow -S . --dir=home --target="$HOME"
stow -S . --dir=systemd --target="$HOME" --no-folding
cd "$DIR" || exit 1

echo "Succesfully stowed dotfiles!"
