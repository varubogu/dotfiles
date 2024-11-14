#!/bin/bash

# 未定義変数があったらエラー
# エラーが発生した場合はスクリプトを終了
set -eu

REPO_OWNER="varubogu"
REPO_NAME="dotfiles"
REPO_URL="https://github.com/$REPO_OWNER/$REPO_NAME.git"
REPO_RAW="https://raw.github.com/$REPO_OWNER/$REPO_NAME"
BRANCH="main"
BIN_DIR=$HOME/.local/bin

#!/bin/bash

is_command_available() { command -v "$1" &> /dev/null; }

is_linux() { [ "$(uname)" = "Linux" ]; }

is_mac() { [ "$(uname)" = "Darwin" ];}

is_wsl() { grep -qEi "(Microsoft|WSL)" /proc/version; }

is_windows() {
    case "$(uname -r)" in
        *Microsoft*)
            return 0
            ;;
        *CYGWIN*|*MINGW*|*MSYS*)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}


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
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
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
    if [ -d $HOME/.local/share/yadm/repo.git ]; then
        echo "yadm is already initialized"
        yadm pull origin $BRANCH
    else
        echo "yadm is none repository. Cloning dotfiles..."
        yes | yadm clone $REPO_URL

        if [[ ! -f "$HOME/.local/share/yadm/repo.git/info/sparse-checkout" ]]; then
            # 不要なファイルを除外して再読み込みする
            yadm config core.sparseCheckout true
            cp $HOME/.config/yadm/sparse-checkout "$HOME/.local/share/yadm/repo.git/info/sparse-checkout"
            yadm checkout main
        fi
    fi
}

main() {
    cd $HOME || exit

    if is_mac; then
        # Macの場合、パッケージ管理ソフトが無いのでbrewをインストール
        setup_brew
    fi

    setup_yadm

    # 各シェルに実行権限付与
    echo "chmod +x to bash scripts"
    find $HOME/.local/bin -name "*.bash" -exec chmod +x {} \;

    # XDG Base Directory Specificationを設定
    echo "XDG Base Directory Specification"
    . $HOME/.config/xdg_base_dir/set_env.bash
    . $HOME/.config/xdg_base_dir/xdg_base_app.bash

    #　環境に合わせてパッケージをインストール
    if is_mac; then
        echo "mac install"
        . $BIN_DIR/install/install_mac.zsh
        echo "Installed mac dotfiles successfully!"
    else
        if is_command_available apt-get; then
            echo "apt-get install"
            . $BIN_DIR/install/install_apt-get.bash
            echo "Installed apt dotfiles successfully!"
        fi
    fi

    # シンボリックリンクを貼る
    echo "symlink execution"
    . $BIN_DIR/symlink/symlink.bash

    if [[ "$SHELL" == *"/zsh"* ]]; then
        echo "zshrc execution"
        . $HOME/.zshrc
    elif [[ "$SHELL" == *"/bash"* ]]; then
        echo "bashrc execution"
        . $HOME/.bashrc
    fi

    if is_wsl; then
        if [ -r "/mnt/c/Users" ]; then
            # ホストのPowerShellからユーザー名を取得し、改行コードを削除
            export WIN_USERNAME=$(powershell.exe '$env:USERNAME' | tr -d '\r')
            # Windowsのユーザーフォルダのパス
            export WIN_HOME="/mnt/c/Users/$WIN_USERNAME"

            echo "Creating symlink to Windows home directory..."
            if [ ! -L $HOME/windows_home ]; then
                echo "Created symlink: $HOME/windows_home -> $WIN_HOME"
                ln -s "$WIN_HOME" $HOME/windows_home
            fi
        fi
    fi

    echo "Installed dotfiles successfully!"
}

main
