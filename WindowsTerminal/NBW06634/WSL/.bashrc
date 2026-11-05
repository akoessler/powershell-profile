#!/bin/bash

# Java (OpenJDK 25)
export JAVA_HOME=/usr/lib/jvm/temurin-25-jdk-amd64
export PATH=$PATH:$JAVA_HOME/bin

# Flutter (FVM)
export PATH="$HOME/fvm/bin:$PATH"
export PATH="$HOME/fvm/default/bin:$PATH"
export PUB_CACHE="$HOME/.pub-cache"
export PATH="$PATH:$PUB_CACHE/bin"

# Android tools
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

