#!/bin/bash

echo_light_purple "on WSL: $WSL_DISTRO_NAME ..."

export SHELLTYPE=WSL

export PATH_TEMPLATE="/mnt/%s/%s"

export HOMEBREW_PATH="/home/linuxbrew/.linuxbrew/bin/brew"
if [[ -f "$HOMEBREW_PATH" ]]; then
    echo "  Init homebrew"
    eval "$($HOMEBREW_PATH shellenv)"
else
    echo_gray "Skip homebrew"
fi

if [[ -z "$SSH_AUTH_SOCK" ]]; then
    echo "  Init ssh-agent"
    eval `ssh-agent -s` > /dev/null
    #ssh-add ~/.ssh/id_ed25519
else
    echo_gray "  Skip ssh-agent"
fi
