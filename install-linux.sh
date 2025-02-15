#!/bin/bash


##### install packages

sudo apt install -y \
\
apt-transport-https base-files base-passwd bash bsdutils build-essential buildah ca-certificates clang cmake curl daemonize dash dbus-user-session diffutils file findutils fontconfig gcc gedit git git-svn gnupg golang-go gpg grep gzip hostname init jq lsb-release mono-devel moreutils nano net-tools ninja-build openssh-server openssh-client perl perl-doc pipx podman pkg-config procps python3-full python3-pip skopeo subversion tree unzip virtualenv wget xz-utils yq zip



##### additional packages

### helm
## https://helm.sh/docs/intro/install/

# curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
# sudo apt-get install apt-transport-https --yes
# echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
# sudo apt-get update
# sudo apt-get install helm
# helm version


### kubectl
## https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

# curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
# sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring
# echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
# sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly
# sudo apt-get update
# sudo apt-get install -y kubectl
# kubectl version --client


### trivy
## https://trivy.dev/latest/getting-started/installation/

# sudo apt-get install wget gnupg
# wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
# echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
# sudo apt-get update
# sudo apt-get install trivy
# trivy version


### openjdk
## https://marcolenzo.eu/install-java-temurin-jdks-instead-of-openjdk/

# sudo apt install -y wget apt-transport-https
# echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print $2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
# sudo mkdir -p /etc/apt/keyrings
# wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo tee /etc/apt/keyrings/adoptium.asc
# sudo apt update
# sudo apt install -y temurin-21-jdk
# java -version


### oh-my-posh
## https://ohmyposh.dev/docs/installation/linux

# curl -s https://ohmyposh.dev/install.sh | sudo bash -s -- -d /usr/local/bin


### homebrew
## https://brew.sh/

# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


##### Commands

### get manually installed packages:
# apt list --manual-installed | sed 's/\// /' | awk '{print $1}'


### set root password
# sudo passwd root

