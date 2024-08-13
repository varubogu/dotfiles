#!/bin/bash

set -eu

REPO_OWNER="varubogu"
REPO_NAME="dotfiles"
REPO_URL="https://github.com/$REPO_OWNER/$REPO_NAME.git"
REPO_RAW="https://raw.github.com/$REPO_OWNER/$REPO_NAME"
BRANCH="main"
DOT_BIN_DIR=".local/bin"
BIN_DIR=~/$REPO_NAME/$DOT_BIN_DIR
INIT_DIR=$BIN_DIR/init

. $BIN_DIR/lib/command.sh
. $BIN_DIR/lib/env_os.sh

setup_brew() {
    echo "Checking brew..."
    if is_command_available brew; then
        echo "brew already installed"
    else
        echo "brew is not installed."
        if is_mac; then
            echo "mac brew installation..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            echo "brew installed successfully"
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
            echo "mac brew setting done"
        elif is_linux; then
            echo "linux brew skip"
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
        yadm pull origin $BRANCH
    else
        echo "yadm is none repository. Cloning dotfiles..."
        yadm clone $REPO_URL
    fi
}

clone_dotfiles() {
    if [ -d $REPO_NAME ]; then
        echo "dotfiles already cloned"
        cd $REPO_NAME || exit
        git pull origin $BRANCH
        cd ../
    else
        echo "Cloning dotfiles..."
        git clone $REPO_URL $REPO_NAME
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
    . $BIN_DIR/xdg_base_dir/xdg_base_dir.sh
    . $BIN_DIR/xdg_base_dir/xdg_base_app.sh

    echo "Installed dotfiles successfully!"

    if is_mac; then
        echo "mac install"
        . $INIT_DIR/install_mac.sh
    fi

    if is_command_available apt; then
        echo "apt install"
        . $INIT_DIR/install_apt.sh
    fi

    # シンボリックリンクを貼る
    . $INIT_DIR/symlink.sh

    if is_command_available zsh; then
        . ~/dotfiles/.config/zsh/.zshrc
    else
        . ~/dotfiles/.config/bash/.bashrc
    fi
}

main
