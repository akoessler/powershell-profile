#!/bin/bash

# use nvm to find all currently installed node versions, find the latest version, and install it, and uninstall older versions
function update-node() {
    echo ""
    echo_light_purple "Updating nvm..."
    latest_nvm_version=$(curl -s "https://api.github.com/repos/nvm-sh/nvm/tags" | jq -r '.[0].name')
    current_nvm_version=$(nvm --version) || true
    echo "Current nvm version: $current_nvm_version"
    echo "Latest nvm version: $latest_nvm_version"
    if [ "$latest_nvm_version" != "v$current_nvm_version" ]; then
        echo_light_blue "Updating nvm to $latest_nvm_version..."
        curl -s -o- https://raw.githubusercontent.com/nvm-sh/nvm/"$latest_nvm_version"/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

        echo ""
        echo_green "nvm updated successfully."
        nvm --version
    else
        echo_green "nvm is already up-to-date."
    fi

    echo ""
    echo_light_purple "Updating node versions..."
    current_versions=$(nvm ls --no-colors --no-alias)
    echo "$current_versions" | while IFS= read -r version_line; do
        # version_line is in format "->     v26.12.1 *"
        echo "Processing version line: $version_line"
        current_version=$(echo "$version_line" | sed -E 's/.*v([0-9]+\.[0-9]+\.[0-9]+).*/\1/')
        major_version=$(echo "$current_version" | sed -E 's/([0-9]+)\..*/\1/')
        if [ -n "$major_version" ]; then
            echo_light_blue "Updating Node version $major_version..."
            newest_version=$(nvm ls-remote "v$major_version" | tail -1 | sed -E 's/.*v([0-9]+\.[0-9]+\.[0-9]+).*/\1/')
            echo "  Installed version: $current_version"
            echo "  Newest version: $newest_version"
            if [ "$newest_version" != "$current_version" ]; then
                nvm install "$newest_version" --reinstall-packages-from="$current_version" --latest-npm
                nvm uninstall "$current_version"
            else
                echo_green "Node version $current_version is already up-to-date."
            fi

        else
            echo_red "Skipping failed version '$current_version'..."
        fi
    done
}

export -f update-node
