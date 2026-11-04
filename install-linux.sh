#!/bin/bash


##### Commands

### set root password to allow su
sudo passwd root

### get manually installed packages:
# apt list --manual-installed | sed 's/\// /' | awk '{print $1}'


##### install packages

sudo apt update
sudo apt install -y \
    apt-transport-https base-files base-passwd bat bash bsdutils build-essential buildah btop \
    ca-certificates clang cmake curl daemonize dash dbus-user-session diffutils file findutils \
    fontconfig fzf gcc gedit git git-svn gnupg golang-go gpg grep gdb gzip hostname htop init jq less \
    lsb-release man-db mono-devel moreutils nano neovim net-tools ninja-build openssh-server openssh-client \
    perl perl-doc pipx podman podman-compose pkg-config procps python3-full python3-pip ripgrep \
    rlwrap rsync sed skopeo subversion sudo tree unzip virtualenv wget whois xz-utils yq zip zsh



##### additional packages

# oh-my-posh
# https://ohmyposh.dev/docs/installation/linux

mkdir ~/bin
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/bin


# homebrew
# https://brew.sh/

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


# PowerShell installation on Debian
# https://learn.microsoft.com/en-us/powershell/scripting/install/install-debian

sudo apt-get update
sudo apt-get install -y wget
source /etc/os-release
wget -q https://packages.microsoft.com/config/debian/$VERSION_ID/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y powershell
pwsh


# dotnet
# https://learn.microsoft.com/en-us/dotnet/core/install/linux-debian

wget https://packages.microsoft.com/config/debian/13/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt-get install -y dotnet-sdk-10.0 dotnet-runtime-10.0 aspnetcore-runtime-10.0
dotnet --version


# openjdk
# https://marcolenzo.eu/install-java-temurin-jdks-instead-of-openjdk/

echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print $2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
sudo mkdir -p /etc/apt/keyrings
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo tee /etc/apt/keyrings/adoptium.asc
sudo apt update
sudo apt install -y temurin-25-jdk
java -version


# vscode
# https://code.visualstudio.com/docs/setup/linux

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft.gpg
sudo tee /etc/apt/sources.list.d/vscode.sources > /dev/null <<EOF
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF
sudo apt update
sudo apt install -y code


# nvm
# https://github.com/nvm-sh/nvm#git-install

export NVM_DIR="$HOME/.nvm" && (
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm use --lts


# trivy
# https://trivy.dev/docs/latest/getting-started/installation/

sudo apt-get install wget gnupg
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy
trivy --version


# helm
# https://helm.sh/docs/intro/install/

HELM_BUILDKITE_APT_KEY_ID="DDF78C3E6EBB2D2CC223C95C62BA89D07698DBC6"
sudo apt-get install curl gpg --yes
curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey > "${TMPDIR:-/tmp}/helm.asc"
# Ensure that the key ID matches to prevent a repository compromise from establishing an attacker controlled key
if [ "$(gpg --import --import-options=show-only --with-colons "${TMPDIR:-/tmp}/helm.asc" \
        | awk -F: '$1 == "fpr" {print $10}' | head -n 1)" != "${HELM_BUILDKITE_APT_KEY_ID}" ]; then
    echo "ERROR: Unexpected Helm APT key ID: potential key compromise"
    exit 1
fi
# Remove configuration left by earlier versions of these instructions
sudo rm -f /etc/apt/sources.list.d/helm-stable-debian.list /usr/share/keyrings/helm.gpg
sudo install -m 0644 -Dt /etc/apt/keyrings/ "${TMPDIR:-/tmp}/helm.asc"
sudo tee /etc/apt/sources.list.d/helm-stable-debian.sources > /dev/null <<EOF
Types: deb
URIs: https://packages.buildkite.com/helm-linux/helm-debian/any/
Suites: any
Components: main
Signed-By: /etc/apt/keyrings/helm.asc
EOF
sudo apt-get update
sudo apt-get install helm
helm version


# kubectl
# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.37/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.37/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly
sudo apt-get update
sudo apt-get install -y kubectl
kubectl version --client


# k9s
# https://k9scli.io/topics/install/

brew install derailed/k9s/k9s

