#!/bin/bash

. $HOME/.local/lib/functions.bash

# 引数チェック
is_root=${1:-true}

# アーキテクチャ判定
arch=$(dpkg --print-architecture)

cd "$HOME/" || exit

echo_log_info "apt-get update..."
sudo apt-get update && sudo apt-get upgrade -y

echo_log_info "locale to japan ..."
sudo apt-get -y install language-pack-ja

echo_log_info "installing tools..."
sudo apt-get install git zsh curl wget tree unzip fontconfig ca-certificates gnupg lsb-release -y

if ! is_command_available brew && [ "$is_root" = "true" ]; then
    if [ "$arch" = "x86_64" ]; then
        echo_log_info "installing HomeBrew..."
        sudo apt-get install build-essential procps file -y
        yes "" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo_log_error "HomeBrew is not supported on $arch"
    fi
fi

if is_command_available brew && [ -f "$XDG_CONFIG_HOME/brew/Brewfile" ]; then
    echo_log_info "installing brew packages..."
    brew bundle $XDG_CONFIG_HOME/brew/Brewfile
fi

if ! is_command_available 1password && [ "$is_root" = "true" ]; then
    if [ "$arch" = "x86_64" ]; then
        echo_log_info "installing 1password..."
        curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
        echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
        sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
        curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
        sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
        curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
        sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
        curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
        sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
        sudo apt-get update && sudo apt-get install 1password 1password-cli -y
    else
        echo_log_error "1password is not supported on $arch"
    fi
fi

if ! is_command_available docker && [ "$is_root" = "true" ]; then
    echo_log_info "installing docker ..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io -y
    sudo apt-get install docker-compose-plugin -y
fi

# Fonts
sudo apt-get install fonts-powerline fonts-jetbrains-mono -y

# Starship
curl -sS https://starship.rs/install.sh | FORCE=1 sh
