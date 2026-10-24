#!/bin/bash

function update() {
    echo_light_purple "Starting system update..."

    echo ""
    echo_light_blue "Updating package lists..."
    sudo apt-get update -y

    echo ""
    echo_light_blue "Upgrading packages..."
    sudo apt-get upgrade -y

    echo ""
    echo_light_blue "Performing distribution upgrade..."
    sudo apt-get dist-upgrade -y

    echo ""
    echo_light_blue "Performing full upgrade..."
    sudo apt-get full-upgrade -y

    echo ""
    echo_light_blue "Removing unnecessary packages..."
    sudo apt-get autoremove -y

    echo ""
    echo_light_blue "Updating PowerShell..."
    update-powershell

    echo ""
    echo_light_blue "Updating node..."
    update-node

    echo ""
    echo_light_purple "System update completed."
    echo ""
}

export -f update
