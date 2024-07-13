#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export POWERSHELL_PROFILE_DIR=$SCRIPT_DIR

. $POWERSHELL_PROFILE_DIR/WindowsTerminal/.bashrc
