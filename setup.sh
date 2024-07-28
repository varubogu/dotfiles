#!/bin/bash

DOTFILES_REPO_URL="https://github.com/varubogu/dotfiles.git"
DOTFILES_BRANCH="main"

if_git_installed() {
    if command -v git &> /dev/null; then
        return 0
    else
        return 1
    fi
}

if_brew_installed() {
    if command -v brew &> /dev/null; then
        return 0
    else
        return 1
    fi
}

if_apt_installed() {
    if command -v apt-get &> /dev/null; then
        return 0
    else
        return 1
    fi
}

checking_git() {
    echo "Checking git..."
    if if_git_installed; then
        echo "git already installed"
    else
        echo "git is not installed. Installing git..."
        if if_brew_installed; then
            brew install git
        elif if_apt_installed; then
            sudo apt-get update
            sudo apt-get install -y git
        else
            echo "Unable to install git. Please install it manually."
            exit 1
        fi
    fi
}

yadm_ready() {
    echo "Checking yadm..."
    if command -v yadm &> /dev/null; then
        echo "yadm already installed"
    else
        echo "yadm is not installed. Installing yadm..."
        if if_brew_installed; then
            brew install yadm
        elif if_apt_installed; then
            sudo apt-get update && sudo apt-get install -y yadm
        else
            echo "Unable to install yadm. Please install it manually."
            exit 1
        fi
    fi
}
yadm_latest() {
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
    checking_git
    yadm_ready
    yadm_latest

    # 各シェルに実行権限付与
    find ~/dotfiles -name "*.sh" -exec chmod +x {} \;

    echo "Installed dotfiles successfully!"
    echo "Please run the following command"
    echo "`echo $SHELL` ~/dotfiles/setup_after.sh"
}

main
