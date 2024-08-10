#!/bin/bash

DOTFILES_REPO_OWNER="varubogu"
DOTFILES_REPO_NAME="dotfiles"
DOTFILES_REPO_URL="https://github.com/$DOTFILES_REPO_OWNER/$DOTFILES_REPO_NAME.git"
DOTFILES_REPO_RAW_URL="https://raw.github.com/$DOTFILES_REPO_OWNER/$DOTFILES_REPO_NAME"
DOTFILES_BRANCH="main"



setup_brew() {
    echo "Checking brew..."
    if is_command_exists brew; then
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
    cd ~/ || exit

    # XDG Base Directory Specification
    sudo curl -sSL $DOTFILES_REPO_RAW_URL/master/.local/bin/xdg_base_dir/xdg_base_dir.sh

    setup_brew
    setup_git
    setup_yadm

    git clone $DOTFILES_REPO_URL $DOTFILES_REPO_NAME

    # 各シェルに実行権限付与
    find ~/dotfiles -name "*.sh" -exec chmod +x {} \;

    . ~/dotfiles/.local/share/functions.sh

    echo "Installed dotfiles successfully!"
    echo "Next step: Run ~/dotfiles/.local/bin/init/install.sh"
    . ~/dotfiles/.local/bin/init/install.sh
}

main
