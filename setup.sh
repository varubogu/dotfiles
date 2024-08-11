#!/bin/bash

set -eu

DOTFILES_REPO_OWNER="varubogu"
DOTFILES_REPO_NAME="dotfiles"
DOTFILES_REPO_URL="https://github.com/$DOTFILES_REPO_OWNER/$DOTFILES_REPO_NAME.git"
DOTFILES_REPO_RAW_URL="https://raw.github.com/$DOTFILES_REPO_OWNER/$DOTFILES_REPO_NAME"
DOTFILES_BRANCH="main"

is_command_available() { command -v "$1" &> /dev/null; }
is_linux() { [ "$(uname)" = "Linux" ]; }
is_mac() { [ "$(uname)" = "Darwin" ];}

setup_brew() {
    echo "Checking brew..."
    if is_command_available brew; then
        echo "brew already installed"
    else
        echo "brew is not installed. Installing brew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo "brew installed successfully"
        if is_mac; then
            echo "mac brew setting"
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
            echo "mac brew setting done"
        elif is_linux; then
            echo "linux brew setting"
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bash_profile
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
            echo "linux brew setting done"
        else
            echo "brew installation failed. Please install it manually."
            exit 1
        fi
    fi
}


setup_git() {
    echo "Checking git..."
    if is_command_available git; then
        echo "git already installed"
    else
        echo "git is not installed. Installing git..."
        if is_command_available brew; then
            brew install git
        elif is_command_available apt-get; then
            sudo apt-get update && sudo apt-get install -y git
        else
            echo "Unable to install git. Please install it manually."
            exit 1
        fi
    fi
}

setup_yadm() {
    echo "Checking yadm..."
    if is_command_available yadm; then
        echo "yadm already installed"
    else
        echo "yadm is not installed. Installing yadm..."
        if is_command_available brew; then
            brew install yadm
        elif is_command_available apt-get; then
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

clone_dotfiles() {
    if [ -d $DOTFILES_REPO_NAME ]; then
        echo "dotfiles already cloned"
        cd $DOTFILES_REPO_NAME || exit
        git pull origin $DOTFILES_BRANCH
        cd ../
    else
        echo "Cloning dotfiles..."
        git clone $DOTFILES_REPO_URL $DOTFILES_REPO_NAME
    fi
}

main() {
    cd ~/ || exit

    setup_brew
    setup_git
    setup_yadm
    clone_dotfiles

    # 各シェルに実行権限付与
    find ~/dotfiles -name "*.sh" -exec chmod +x {} \;

    # XDG Base Directory Specification
    . ~$DOTFILES_REPO_NAME/.local/bin/xdg_base_dir/xdg_base_dir.sh

    echo "Installed dotfiles successfully!"
    . ~/$DOTFILES_REPO_NAME/.local/bin/init/install.sh
}

main
