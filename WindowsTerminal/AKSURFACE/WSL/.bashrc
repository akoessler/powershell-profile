


eval "$(oh-my-posh init bash --config /mnt/d/OneDrive/Documents/PowerShell/oh-my-posh-theme.json)"


export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-arm64
export PATH=$PATH:$JAVA_HOME/bin


if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s` > /dev/null
  #ssh-add ~/.ssh/id_ed25519
fi
