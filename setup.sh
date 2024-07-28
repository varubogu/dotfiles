#!/bin/bash

DOTFILES_REPO_URL="https://github.com/varubogu/dotfiles.git"
DOTFILES_BRANCH="main"

is_command_exists() {
    if command -v $1 &> /dev/null; then
        return 0
    else
        return 1
    fi
}

setup_git() {
    echo "Checking git..."
    if is_command_exists git; then
        echo "git already installed"
    else
        echo "git is not installed. Installing git..."
        if is_brew_installed; then
            brew install git
        elif is_apt_installed; then
            sudo apt-get update
            sudo apt-get install -y git
        else
            echo "Unable to install git. Please install it manually."
            exit 1
        fi
    fi
}

setup_yadm() {
    echo "Checking yadm..."
    if command -v yadm &> /dev/null; then
        echo "yadm already installed"
    else
        echo "yadm is not installed. Installing yadm..."
        if is_command_exists brew; then
            brew install yadm
        elif is_command_exists apt-get; then
            sudo apt-get update && sudo apt-get install -y yadm
        else
            echo "Unable to install yadm. Please install it manually."
            exit 1
        fi
    fi

    echo "Cloning dotfiles..."
    if [ -d ~/.local/share/yadm/repo.git ]; then
        echo "yadm is already initialized"
        yadm pull origin $DOTFILES_BRANCH
    else
        echo "yadm is none repository. Cloning dotfiles..."
        yadm clone $DOTFILES_REPO_URL
    fi
}


main() {
    # XDG Base Directory Specification
    bash -c "$( curl -fsSL https://raw.github.com/varubogu/dotfiles/master/.local/bin/init/xdg_base_dir.sh )"

    setup_git
    setup_yadm

    # 各シェルに実行権限付与
    find ~/dotfiles -name "*.sh" -exec chmod +x {} \;

    echo "Installed dotfiles successfully!"
    echo "Please run the following command"
}

main
