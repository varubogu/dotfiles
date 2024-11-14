#!/bin/zsh

BIN_DIR=$HOME/.local/bin

. $BIN_DIR/lib/command.bash
. $BIN_DIR/lib/env_os.bash

if is_wsl; then
    . $BIN_DIR/lib/env_wsl.bash
    # SSH by Host(Windows)
    alias ssh='ssh.exe'
    alias ssh-add='ssh-add.exe'
fi

# Homebrewのエイリアスと設定
if is_command_available brew; then
    alias brewup='brew update && brew upgrade'
    export PATH="/opt/homebrew/bin:$PATH"
fi

# パッケージのアップデートコマンド
alias pup=$BIN_DIR/mng/pkg_update.bash

# パッケージのインストールコマンド
alias pins=$BIN_DIR/mng/pkg_install.bash

# Create package list
alias pdump=$BIN_DIR/mng/pkg_dump.bash

# Print dotfiles structure
alias pstr=$BIN_DIR/struct/print_struct.bash
