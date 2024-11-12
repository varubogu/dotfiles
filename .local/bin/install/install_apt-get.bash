#!/bin/bash

set -e

# 引数チェック
is_root="$1"


cd "$HOME/" || exit

echo "apt-get update..."
sudo apt-get update && sudo apt-get upgrade -y

echo "locale to japan ..."
sudo apt-get -y install language-pack-ja
sudo update-locale LANG=ja_JP.UTF8

echo "installing tools..."
sudo apt-get install git zsh curl wget ca-certificates gnupg lsb-release -y

if [ "$is_root" = "true" ]; then
    echo "installing HomeBrew..."
    sudo apt-get install build-essential procps file -y
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "installing 1password..."
sudo -s \
curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
gpg --yes --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" |
tee /etc/apt/sources.list.d/1password.list
mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
gpg --yes --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
apt-get update && apt-get install 1password 1password-cli -y

echo "installing docker ..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo apt-get install docker-compose-plugin -y

echo "installing oh-my-zsh ..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


