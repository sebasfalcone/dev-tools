#/bin/sh
# Debian
# July 25, 2022

[ $_ = $0 ] || sourced=0

set -e
source shared/shared.sh
source /etc/os-release

apt-get-install() {
    echo "Installing new package"
    DEBIAN_FRONTEND='noninteractive' apt-get install -y $@
}

apt-get-upgrade() {
    echo "Upgrading packages"
    DEBIAN_FRONTEND='noninteractive' apt-get upgrade -y
}

apt-get-update() {
    echo "Updating packages sources"
    apt-get update
}

apt-key-add() {
    APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add -
}

setup_packages() {
    echo "Setting up packages"
    apt-get-update

    apt-get-install apt-transport-https
    apt-get-install nano
    apt-get-install curl
    apt-get-install wget
    apt-get-install git
    apt-get-install net-tools
    apt-get-install gnupg2
    apt-get-install ca-certificates
    apt-get-install lsb-release
    apt-get-install software-properties-common

    apt-get-install build-essential
    apt-get-install libssl-dev
    apt-get-install patchelf
    apt-get-install python3
    apt-get-install python3-pip
    apt-get-install net-tools
    apt-get-install cmake
    apt-get-install clang
    apt-get-install ninja-build
    apt-get-install mysql-server
    apt-get-install postgresql-client
    apt-get-install heaptrack heaptrack-gui

    # VSCODE
    echo "Installing vscode"

    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EB3E94ADBE1229CF
    add-apt-repository -y "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    apt-get-update
    apt-get-install code  

    # MongoDB
    echo "Installing mongoDB"

    wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | gpg --dearmor | tee /usr/share/keyrings/mongodb.gpg > /dev/null
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list
    apt-get-update
    apt-get-install mongodb-org

    # DOCKER
    echo "Installing docker"

    apt-get-update
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt-get-update
    apt-cache policy docker-ce
    apt-get-install docker-ce

    sudo systemctl status docker

    sudo usermod -aG docker vagrant
    newgrp docker
}

if [ -z "$sourced" ]
then
    setup_packages
    setup_shared
fi
