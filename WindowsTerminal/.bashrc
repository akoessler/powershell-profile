#!/bin/bash

if [[ -z "$POWERSHELL_PROFILE_DIR" ]]; then
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    export POWERSHELL_PROFILE_DIR=$SCRIPT_DIR/../
fi

. $POWERSHELL_PROFILE_DIR/WindowsTerminal/.bashcolors


echo_light_purple "Init bash ..."
echo "  POWERSHELL_PROFILE_DIR=$POWERSHELL_PROFILE_DIR"


if [[ -n "$WSL_DISTRO_NAME" ]]; then
    . $POWERSHELL_PROFILE_DIR/WindowsTerminal/wsl.sh
fi

if [[ "$MSYSTEM" = "MINGW64" ]]; then
    . $POWERSHELL_PROFILE_DIR/WindowsTerminal/gitbash.sh
fi


echo_light_purple "Init tools ..."

echo "  Init oh-my-posh"
eval "$(oh-my-posh init bash --config $POWERSHELL_PROFILE_DIR/oh-my-posh-theme.json)"


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


echo_light_purple "Init custom-functions ..."

for UTIL_FILE in $POWERSHELL_PROFILE_DIR/WindowsTerminal/custom-functions/*.sh; do
    echo "  Source $UTIL_FILE"
    . $UTIL_FILE
done


echo_green "Finished."
echo ""
