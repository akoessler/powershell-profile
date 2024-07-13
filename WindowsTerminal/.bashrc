#!/bin/bash

if [[ -z "$POWERSHELL_PROFILE_DIR" ]]; then
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    export POWERSHELL_PROFILE_DIR=$SCRIPT_DIR/../
fi

. $POWERSHELL_PROFILE_DIR/WindowsTerminal/.bashcolors

echo_light_purple "Init bash ..."
echo "  POWERSHELL_PROFILE_DIR=$POWERSHELL_PROFILE_DIR"

echo "  Init oh-my-posh"
eval "$(oh-my-posh init bash --config $POWERSHELL_PROFILE_DIR/oh-my-posh-theme.json)"

if [[ -n "$WSL_DISTRO_NAME" ]]; then
    SHELLTYPE=WSL
    echo_light_purple "on WSL: $WSL_DISTRO_NAME ..."

    HOMEBREW_PATH="/home/linuxbrew/.linuxbrew/bin/brew"
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

fi

if [[ "$MSYSTEM" = "MINGW64" ]]; then
    SHELLTYPE=MINGW64
    echo_light_purple "on MSYSTEM: $MSYSTEM ..."
fi

echo_light_purple "Init host specific ..."

HOST_SPECIFIC_FILE=$POWERSHELL_PROFILE_DIR/WindowsTerminal/$HOSTNAME/$SHELLTYPE/.bashrc
if [[ -f "$HOST_SPECIFIC_FILE" ]]; then
    echo "  Source $HOST_SPECIFIC_FILE"
    . $HOST_SPECIFIC_FILE
else
    echo_gray "  Skip $HOST_SPECIFIC_FILE"
fi

HOST_SPECIFIC_FILE=$POWERSHELL_PROFILE_DIR/WindowsTerminal/$HOSTNAME/.bashrc
if [[ -f "$HOST_SPECIFIC_FILE" ]]; then
    echo "  Source $HOST_SPECIFIC_FILE"
    . $HOST_SPECIFIC_FILE
else
    echo_gray "  Skip $HOST_SPECIFIC_FILE"
fi

echo_green "Finished."
echo ""
