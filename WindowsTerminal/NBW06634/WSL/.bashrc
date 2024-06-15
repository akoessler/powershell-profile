
eval "$(oh-my-posh init bash --config /mnt/c/Users/ankoessler/Documents/PowerShell/oh-my-posh-theme.json)"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

export PATH="/home/ankoessler/flutter/bin:$PATH"

export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin

export ANDROID_HOME=/home/ankoessler/android
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/tools/bin
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/platform-tools

if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s`
  #ssh-add ~/.ssh/id_ed25519
fi
