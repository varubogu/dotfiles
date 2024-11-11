#!/bin/bash

# 未定義変数があったらエラー
# エラーが発生した場合はスクリプトを終了
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

        if [[ ! -f "${YADM_HOOK_REPO}/info/sparse-checkout" ]]; then
            # 不要なファイルを除外して再読み込みする
            yadm config core.sparseCheckout true
            cp ~/.config/yadm/sparse-checkout "${YADM_HOOK_REPO}/info/sparse-checkout"
            yadm checkout main
        fi
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
    echo "chmod +x"
    find ~/dotfiles -name "*.sh" -exec chmod +x {} \;

    # XDG Base Directory Specification
    echo "XDG Base Directory Specification"
    . $BIN_DIR/xdg_base_dir/xdg_base_dir.sh
    . $BIN_DIR/xdg_base_dir/xdg_base_app.sh

    if is_mac; then
        echo "mac install"
        . $INIT_DIR/install_mac.sh
        echo "Installed mac dotfiles successfully!"
    fi

    if is_command_available apt-get; then
        echo "apt-get install"
        . $INIT_DIR/install_apt-get.sh
        echo "Installed apt dotfiles successfully!"
    fi

    # シンボリックリンクを貼る
    echo "symlink execution"
    . $INIT_DIR/symlink.sh

    if is_command_available zsh; then
        echo "zshrc execution"
        . ~/dotfiles/.config/zsh/.zshrc
    else
        echo "bashrc execution"
        . ~/dotfiles/.config/bash/.bashrc
    fi

    if is_wsl; then
        # ホストのPowerShellからユーザー名を取得し、改行コードを削除
        export WIN_USERNAME=$(powershell.exe '$env:USERNAME' | tr -d '\r')
        # Windowsのユーザーフォルダのパス
        export WIN_HOME="/mnt/c/Users/$WIN_USERNAME"

        echo "Creating symlink to Windows home directory..."
        if [ ! -L ~/windows_home ]; then
            echo "Created symlink: ~/windows_home -> $WIN_HOME"
            ln -s "$WIN_HOME" ~/windows_home
        fi
    fi

    echo "Installed dotfiles successfully!"
}

main
