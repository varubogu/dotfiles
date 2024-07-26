#!/bin/bash

source "$HOME/dotfiles/lib/env"

if command -v git &> /dev/null; then
    echo "git already installed"
else
    echo "git is not installed. Installing git..."
    if command -v brew &> /dev/null; then
        brew install git
    elif command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y git
    else
        echo "Unable to install git. Please install it manually."
        exit 1
    fi
fi

if [ ! -d ~/dotfiles ]; then
    echo "dotfiles is not found"
    git clone https://github.com/varubogu/dotfiles.git ~/dotfiles
else
    echo "dotfiles is found"
    git -C ~/dotfiles pull
fi

echo "Do you want to start the installation? (y/N)"
read answer

if [[ ! $answer =~ ^[Yy]$ ]]; then
    echo "Installation aborted."
    exit 0
fi

echo "Starting installation..."


# 各シェルに実行権限付与
find ~/dotfiles -name "*.sh" -exec chmod +x {} \;
~/dotfiles/bin/init/install.sh