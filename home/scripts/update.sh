#!/usr/bin/env bash

NIX_LOCATION="$HOME/.config/nix"

set -eE
trap 'echo "Error in $0: \`$BASH_COMMAND\` exited with status $?"' ERR

echo "Detecting OS..."

dotfiles() {
    if [[ -f ~/dotfiles/install.sh ]]; then
        ~/dotfiles/install.sh
        echo
    fi
}

tealdeer() {
    if command -v tldr >/dev/null 2>&1; then
        echo "Updating tldr cache..."
        tldr --update
        echo
    fi
}

UNAME="$(uname)"

if [[ "$UNAME" == "Darwin" ]]; then
    echo "Found macOS"
    if command -v nix >/dev/null 2>&1; then
        echo "Updating nix-darwin..."
        nix flake update --flake "$NIX_LOCATION"
        sudo darwin-rebuild switch --flake "$NIX_LOCATION"#"$(scutil --get LocalHostName)"
        nix-collect-garbage --delete-older-than 7d
    fi

    if command -v mas >/dev/null 2>&1; then
        echo "Updating App Store apps..."
        mas upgrade
    else
        echo "mas not found, skipping App Store updates"
    fi

    dotfiles
    tealdeer

    echo "Updating macOS..."
    SOFTWAREUPDATE=$(softwareupdate --list 2>&1)
    if [[ ! "${SOFTWAREUPDATE}" =~ "No new software available" ]]; then
        echo "Update(s) found"
        echo "${SOFTWAREUPDATE}"
        if [[ "${SOFTWAREUPDATE}" =~ "Action: restart" ]]; then
            echo "At least 1 update requires a restart"
            read -r -p "Do you want to install  the update(s) requiring a restart? [y/N] " response
            if [[ "${response,,}" =~ ^(yes|y)$ ]]; then
                echo "Updating..."
                sudo softwareupdate --install --recommended --restart
            else
                echo "Updating... (Skipping updates requiring restart)"
                sudo softwareupdate --install --recommended
            fi
        else
            sudo softwareupdate --install --recommended
        fi
    else
        echo "No updates found"
    fi
    echo
elif [[ "$UNAME" == "Linux" ]]; then
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
    fi
    if [[ "$ID" = "gentoo" ]]; then
        echo "Found Gentoo";

        sudo bash -c '
        echo "Syncing repository...";
        emerge --sync;
        echo;

        echo "Updating system...";
        emerge --ask --verbose --update --deep --newuse @world;
        echo;
        echo "Before continueing, make sure you have read any potential messages above";
        read -r -p "Press enter to continue " response;
        echo;

        echo "Cleaning up...";
        emerge --depclean;
        eclean --deep distfiles;
        eclean --deep packages;
        '
    fi

    if [[ "$ID" = "arch" ]]; then
        echo "Found Arch"
        if command -v yay >/dev/null 2>&1; then
            yay
        elif command -v paru >/dev/null 2>&1; then
            paru -Syyu
        else
            sudo pacman -Syyu
        fi
        sudo pacman -Scc
        sudo pacman -Rcns "$(pacman -Qdtq)"
        echo
    fi

    if [[ "$ID" = "debian" ]]; then
        echo "Found Debian"
        echo "Syncing repository..."
        sudo apt update
        echo
        echo "Updating system..."
        sudo apt upgrade -y
        echo
    fi

    if command -v flatpak >/dev/null 2>&1; then
        echo "Updating flatpaks..."
        flatpak update --user -y
        echo
    fi
    dotfiles
    tealdeer
else
    echo "OS not found, exiting..."
    exit 1
fi

echo "Completed system update!"
