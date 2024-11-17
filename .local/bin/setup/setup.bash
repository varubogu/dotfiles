#!/bin/bash

# Exit script on error
set -e

# .local/lib/functions.bash start

echo_log() {
    echo "***dotfiles[$1] $2"
}

echo_log_info() {
    echo_log "INFO" "$1"
}

echo_log_error() {
    echo_log "ERROR" "$1"
}

echo_log_warn() {
    echo_log "WARN" "$1"
}

is_command_available() { command -v "$1" &> /dev/null; }


is_linux() { [ "$(uname)" = "Linux" ]; }

is_mac() { [ "$(uname)" = "Darwin" ];}

is_wsl() {
    [ -n "${WSL_DISTRO_NAME}" ] || \
    [ -n "${WSLG_DIR}" ] || \
    (grep -qEi "(Microsoft|WSL)" /proc/version 2>/dev/null && \
    [ -r "/mnt/c/Users" ])
}

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


echo_env() {
    echo_log_info "TERM: $TERM Shell: $SHELL"
    echo_log_info "OS: $(uname)"
    echo_log_info "LANG: $LANG"
    echo_log_info "Home: $HOME PWD: $PWD"
    echo_log_info "User: $USER"
    echo_log_info "Editor: $EDITOR"
}

# .local/lib/functions.bash end





# デフォルトはtrue、-norootオプションがある場合はfalseに設定
is_root=true
for arg in "$@"; do
    case $arg in
        --noroot)
            is_root=false
            shift
            ;;
    esac
done

REPO_OWNER="varubogu"
REPO_NAME="dotfiles"
REPO_URL="https://github.com/$REPO_OWNER/$REPO_NAME.git"
REPO_RAW="https://raw.github.com/$REPO_OWNER/$REPO_NAME"
BRANCH="main"
BIN_DIR=$HOME/.local/bin




setup_brew() {
    echo_log_info "Checking brew..."
    if is_command_available brew; then
        echo_log_info "brew already installed"
    else
        echo_log_info "brew is not installed."
        if is_mac; then
            echo_log_info "mac brew installation..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            echo_log_info "brew installed successfully"
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zshrc
            eval "$(/opt/homebrew/bin/brew shellenv)"
            echo_log_info "mac brew setting done"
        elif is_linux; then
            echo_log_info "linux brew skip"
        else
            echo_log_error "brew installation failed. Please install it manually."
            exit 1
        fi
    fi
}

setup_yadm() {
    echo "Checking yadm..."
    if is_command_available yadm; then
        echo_log_info "yadm already installed"
    else
        echo_log_info "yadm is not installed. Installing yadm..."
        if is_command_available brew; then
            brew install yadm
        elif is_command_available apt-get; then
            sudo apt-get update && sudo apt-get install -y yadm
        else
            echo_log_error "Unable to install yadm. Please install it manually."
            exit 1
        fi
    fi

    echo "Cloning dotfiles..."
    if [ -d $HOME/.local/share/yadm/repo.git ]; then
        echo_log_info "yadm is already initialized"
        yadm reset HEAD --soft
        yadm pull origin $BRANCH
    else
        echo_log_info "yadm is none repository. Cloning dotfiles..."
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

    # XDG Base Directory Specificationを設定
    echo_log_info "XDG Base Directory Specification"
    . $HOME/.config/xdg_base_dir/set_env.bash

    #　環境に合わせてパッケージをインストール
    if is_mac; then
        echo_log_info "mac install"
        . $BIN_DIR/install/install_mac.zsh
        echo_log_info "Installed mac dotfiles successfully!"
    else
        if is_command_available apt-get; then
            echo_log_info "apt-get install"
            . $BIN_DIR/install/install_apt-get.bash $is_root
            echo_log_info "Installed apt dotfiles successfully!"
        fi
    fi

    # シンボリックリンクを貼る
    echo_log_info "symlink execution"
    . $BIN_DIR/symlink/symlink.bash

    # if [[ "$SHELL" == *"/zsh"* ]]; then
    #     echo "zshrc execution"
    #     . $HOME/.zshrc
    # elif [[ "$SHELL" == *"/bash"* ]]; then
    #     echo "bashrc execution"
    #     . $HOME/.bashrc
    # fi

    if [ -f $HOME/.local/bin/setup/setup.os.bash ]; then
        echo_log_info "os specific setup"
        . $HOME/.local/bin/setup/setup.os.bash
        echo_log_info "os specific setup done"
    fi

    ohmyzsh_root="$HOME/.oh-my-zsh"
    if [ ! -d "$ohmyzsh_root" ]; then
        echo_log_info "installing oh-my-zsh ..."
        echo_log_info "After installation, please type 'exit' to quit the interactive mode"
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

        if [ ! -d "$ohmyzsh_root" ]; then
            echo_log_info "oh-my-zsh already installed"
        else
            echo_log_error "oh-my-zsh installation failed"
            exit 1
        fi
    else
        echo_log_info "oh-my-zsh already installed"
        if is_command_available omz; then
            omz update
        fi
    fi


    echo_log_info "Installed dotfiles successfully!"

    if [[ "$SHELL" == *"/zsh"* ]]; then
        echo_log_info "next step: zshrc reload"
        echo 'source $HOME/.zshrc'
    elif [[ "$SHELL" == *"/bash"* ]]; then
        echo_log_info "next step: zsh execution (requires sudo)"
        echo_log_info 'chsh -s "$(which zsh)"'
        echo_log_info "or"
        echo_log_info "next step: bashrc reload"
        echo_log_info 'source $HOME/.bashrc'
    fi
}

main
