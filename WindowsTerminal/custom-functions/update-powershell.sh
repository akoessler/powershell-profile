#!/bin/bash

function update-powershell() {
    repo_api="https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
    cache_parent="${XDG_CACHE_HOME:-$HOME/.cache}/powershell-deb"
    arch="$(dpkg --print-architecture)"

    if [ "$arch" != "amd64" ] && [ "$arch" != "arm64" ]; then
        printf 'This helper expects amd64 or arm64, but this system reports %s.\n' "$arch" >&2
        return 1
    fi

    mkdir -p "$cache_parent"
    tmp_dir="$(mktemp -d "${cache_parent}/download.XXXXXX")"
    trap 'rm -rf "$tmp_dir"' EXIT

    release_json="$(curl -fsSL "$repo_api")"
    version="$(printf '%s' "$release_json" | python3 -c 'import json, sys; print(json.load(sys.stdin)["tag_name"].lstrip("v"))')"
    deb_name="powershell_${version}-1.deb_${arch}.deb"
    base_url="https://github.com/PowerShell/PowerShell/releases/download/v${version}"
    deb_url="${base_url}/${deb_name}"
    hash_url="${base_url}/hashes.sha256"

    printf 'Installing PowerShell %s from %s\n' "$version" "$deb_url"
    curl -fsSLo "${tmp_dir}/${deb_name}" "$deb_url"
    curl -fsSLo "${tmp_dir}/hashes.sha256" "$hash_url"

    printf 'Verifying %s\n' "$deb_name"
    (
        cd "$tmp_dir"
        iconv -f utf-16 -t utf-8 hashes.sha256 | tr -d '\r' | grep "${deb_name}$" | sha256sum -c -
    )

    sudo apt-get install "${tmp_dir}/${deb_name}" -y

    printf "Version: %s\n" "$(pwsh --version)"
}

export -f update-powershell
