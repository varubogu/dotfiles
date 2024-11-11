#!/bin/zsh

. $HOME/dotfiles/.local/bin/lib/env_os.sh

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
    local dest="$1"
    local src="$2"

    # 引数チェック
    if [ $# -ne 2 ]; then
        echo "Error: Two arguments required." >&2
        return 1
    fi

    # リンク元ファイルの存在チェック
    if [ ! -e "$dest" ]; then
        echo "Error: Source file '$dest' does not exist." >&2
        return 1
    fi

    local can_symlink=false

    if [ -L "$src" ]; then
        # シンボリックリンク作成済み
        echo "$src is already a symbolic link."
        return 0

    elif [ -e "$src" ]; then
        # ファイルが存在する場合は日時付きバックアップを取ってからシンボリックリンクを作成
        local backup_date=$(date '+%Y%m%d%H%M%S')
        local backup_file="${src}.bk.${backup_date}"
        echo "backup ${src} to ${backup_file}"
        # 移動先ファイルの存在チェック
        if [ -e "${backup_file}" ]; then
            echo "Error: already exitst `${backup_file}`"
            echo "To be safe, the function is terminated."
            return 1
        fi
        mv "$src" "${backup_file}"
        can_symlink=true

    else
        # ファイルが存在しない場合はそのままシンボリックリンクを作成
        can_symlink=true
    fi

    if [ "$can_symlink" = true ]; then
        # シンボリックリンクを作成
        echo "Created symbolic link $dest ---> $src"
        ln -s "$dest" "$src"
    fi
}

safe_copy() {
    local dest="$1"
    local src="$2"

    # 引数チェック
    if [ $# -ne 2 ]; then
        echo "Error: Two arguments required." >&2
        return 1
    fi

    # リンク元ファイルの存在チェック
    if [ ! -e "$dest" ]; then
        echo "Error: Source file '$dest' does not exist." >&2
        return 1
    fi

    local can_copy=false

    if [ -e "$src" ]; then
        # ファイルが存在する場合はコピーしない
        echo "$src is already exist."
    else
        # ファイルが存在しない場合はそのままコピーを作成
        can_copy=true
    fi

    if [ "$can_copy" = true ]; then
        # コピーを作成
        echo "Created copy $dest ---> $src"
        cp -r "$dest" "$src"
    fi
}


# パッケージのシンボリックリンクを作成
DOTCONFIG=$HOME/dotfiles/.config
if is_mac; then
    safe_symlink $DOTCONFIG/brew/mac.Brewfile ~/Brewfile
elif is_linux; then
    safe_symlink $DOTCONFIG/brew/linux.Brewfile ~/Brewfile
fi

# 設定ファイルのシンボリックリンクを作成
safe_symlink $DOTCONFIG/ $HOME/.config

safe_symlink $DOTCONFIG/bash/.bashrc $HOME/.bashrc
safe_symlink $DOTCONFIG/bash/.bash_profile $HOME/.bash_profile
safe_symlink $DOTCONFIG/zsh/.zshrc $HOME/.zshrc
safe_symlink $DOTCONFIG/zsh/.zprofile $HOME/.zprofile
safe_symlink $DOTCONFIG/zsh/.zshrc.lazy $HOME/.zshrc.lazy
safe_symlink $DOTCONFIG/editorconfig/.editorconfig $HOME/.editorconfig

if is_mac; then
    safe_symlink $HOME/Movies $HOME/Videos
fi

safe_copy $DOTCONFIG/git/config_local $HOME/.gitconfig
