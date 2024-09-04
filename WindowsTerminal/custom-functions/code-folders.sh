#!/bin/bash

declare -A codeLocations

declare -a CODE_FOLDERS_FILES=(
    "$POWERSHELL_PROFILE_DIR/custom-functions/code-folders.txt"
    "$POWERSHELL_PROFILE_DIR/custom-functions/$HOSTNAME/code-folders.txt"
)

for CODE_FOLDERS_FILE in "${CODE_FOLDERS_FILES[@]}"; do
    if [[ -f "$CODE_FOLDERS_FILE" ]]; then
        while IFS= read -r line; do
            if [[ -n "$line" ]]; then
                read -r key value <<< "$line"
                key=$(echo $key | tr -d '"')
                value=$(echo $value | tr -d '"')
                codeLocations[$key]=$value
            fi
        done < "$CODE_FOLDERS_FILE"
    fi
done

function g() {
    if [[ -n "$1" ]]; then
        value="${codeLocations[$1]}"
        if [[ -n "$value" ]]; then
            cd-platform-independent "$value"
        else
            echo "No code folder defined for $1"
        fi
    else
        echo "Usage: g <code-folder-key>"
    fi
}

export -f g
