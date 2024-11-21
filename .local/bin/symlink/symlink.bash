#!/bin/zsh

. $HOME/.local/lib/functions.bash

# シンボリックリンクを作成する関数
#
# 引数:
#   $1 - シンボリックリンクを貼る元のファイルパス（リンク元）
#   $2 - シンボリックリンクを貼る先のファイルパス（リンク先）
#
# 動作:
# 1. リンク先が既にシンボリックリンクの場合は何もしない
# 2. リンク先にファイルが存在する場合は、バックアップを作成してからリンクを作成
# 3. リンク先にファイルが存在しない場合は、直接リンクを作成
#
# 注意:
# - 既存のファイルはバックアップされます（ファイル名.bk.年月日時分秒の形式）
safe_symlink() {
    local src="$1"
    local dest="$2"

    # 引数チェック
    if [ $# -ne 2 ]; then
        echo_log_error "Error: Two arguments required." >&2
        return 1
    fi

    # リンク元ファイルの存在チェック
    if [ ! -e "$src" ]; then
        echo_log_error "Error: Source file '$src' does not exist." >&2
        return 1
    fi

    local can_symlink=false

    if [ -L "$dest" ]; then
        # シンボリックリンク作成済み
        echo_log_info "already a symbolic link: $dest"
        return 0

    elif [ -e "$dest" ]; then
        # ファイルが存在する場合は日時付きバックアップを取ってからシンボリックリンクを作成
        local backup_date=$(date '+%Y%m%d%H%M%S')
        local backup_file="${dest}.bk.${backup_date}"
        echo_log_info "backup ${dest} to ${backup_file}"
        # 移動先ファイルの存在チェック
        if [ -e "${backup_file}" ]; then
            echo_log_error "Error: already exitst `${backup_file}`"
            echo_log_error "To be safe, the function is terminated."
            return 1
        fi
        mv "$dest" "${backup_file}"
        can_symlink=true

    else
        # ファイルが存在しない場合はそのままシンボリックリンクを作成
        can_symlink=true
    fi

    if [ "$can_symlink" = true ]; then
        # シンボリックリンクを作成
        echo_log_info "Created symbolic link $dest -> $src"
        ln -s "$src" "$dest"
    fi
}

safe_copy() {
    local from="$1"
    local to="$2"

    # 引数チェック
    if [ $# -ne 2 ]; then
        echo_log_error "Error: Two arguments required." >&2
        return 1
    fi

    # リンク元ファイルの存在チェック
    if [ ! -e "$from" ]; then
        echo_log_error "Error: Source file '$from' does not exist." >&2
        return 1
    fi

    local can_copy=false

    if [ -e "$to" ]; then
        # ファイルが存在する場合はコピーしない
        echo_log_info "already exist: $to"
    else
        # ファイルが存在しない場合はそのままコピーを作成
        can_copy=true
    fi

    if [ "$can_copy" = true ]; then
        # コピーを作成
        echo_log_info "Created copy $from -> $to"
        cp -r "$from" "$to"
    fi
}


# パッケージのシンボリックリンクを作成
DOTCONFIG=$HOME/.config
if is_mac; then
    safe_symlink $DOTCONFIG/brew/Brewfile $HOME/Brewfile
elif is_linux; then
    safe_symlink $DOTCONFIG/brew/Brewfile $HOME/Brewfile
fi

safe_symlink $DOTCONFIG/bash/.bashrc $HOME/.bashrc
safe_symlink $DOTCONFIG/bash/.bash_profile $HOME/.bash_profile
safe_symlink $DOTCONFIG/zsh/.zshenv $HOME/.zshenv
safe_symlink $DOTCONFIG/editorconfig/config $HOME/.editorconfig

if is_mac; then
    safe_symlink $HOME/Movies $HOME/Videos
fi

safe_copy $DOTCONFIG/git/config $HOME/.gitconfig
