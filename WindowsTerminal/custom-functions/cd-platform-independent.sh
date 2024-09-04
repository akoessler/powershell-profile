#!/bin/bash

function cd-platform-independent() {
    dst=$1
    if [[ -z "$dst" ]]; then
        echo "Usage: cd-platform-independent <path>"
        return
    fi

    first_char="${dst:0:1}"
    if [[ "$first_char" == "/" ]]; then
        # already a unix path
        dst_unix="$dst"
    else
        # assuming windows path here, e.g. C:\path\to\dir
        second_char="${dst:1:1}"
        if [[ "$second_char" != ":" ]]; then
            echo "Invalid path, second character is not a colon: $dst"
            return
        fi

        drive_lower="${first_char,,}"
        path_win="${dst:3}"
        path_unix="${path_win//\\//}"

        if [[ -n "$PATH_TEMPLATE" ]]; then
            dst_unix=$(printf "$PATH_TEMPLATE" "$drive_lower" "$path_unix")
        else
            dst_unix="/$drive_lower/$path_unix"
        fi
    fi

    if [[ -n "$dst_unix" ]]; then
        echo "cd-platform-independent: ${dst@Q} => ${dst_unix@Q}"
        cd "$dst_unix"
        pwd
    else
        echo "Invalid path, dst_unix could not be calculated from: $dst"
    fi
}

export -f cd-platform-independent
