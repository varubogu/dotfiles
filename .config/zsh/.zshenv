#!/usr/bin/env sh

function add_before_path() {
    local -a targets=("$@")
    for target in "${targets[@]}"; do
        if [ -d "$target" ]; then
            export PATH="$target:$PATH"
        fi
    done
}

function add_after_path() {
    local -a targets=("$@")
    for target in "${targets[@]}"; do
        if [ -d "$target" ]; then
            export PATH="$PATH:$target"
        fi
    done
}

# XDG Base Directory Specification
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export XDG_CONFIG_DIRS="/etc/xdg"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_AUTOSTART_DIR="$XDG_CONFIG_HOME/autostart"

# XDG user directories
export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_PUBLICSHARE_DIR="$HOME/Public"
export XDG_TEMPLATES_DIR="$HOME/Templates"
export XDG_VIDEOS_DIR="$HOME/Videos"

# Zsh specific environment
export ZDOTDIR=$XDG_CONFIG_HOME/zsh
export ZSH_DATA_HOME=$XDG_DATA_HOME/zsh
export ZSH_HISTORY=$ZSH_DATA_HOME/history
export ZSH_HISTFILE=$ZSH_HISTORY/histfile
export ZSH_HISTSIZE=50000
export ZSH_SAVEHIST=100000
export ZSH_LOG_DIR=$ZSH_DATA_HOME/log
export ZSH_PLUGIN_DIR=$ZSH_DATA_HOME/plugins
export ZSH_THEME_DIR=$ZSH_DATA_HOME/themes
export ZSH_CACHE_DIR=$XDG_CACHE_HOME/zsh
export HISTFILE="$ZSH_HISTFILE"
export HISTSIZE="$ZSH_HISTSIZE"
export SAVEHIST="$ZSH_SAVEHIST"

export SSH_CONFIG=$XDG_CONFIG_HOME/ssh
export GNUPGHOME=$XDG_CONFIG_HOME/gnupg

# 日本語化
export LANG=ja_JP.UTF-8
export TZ=Asia/Tokyo

# Local directories
export HOME_LOCAL=$HOME/.local
export LOCAL_BIN_DIR=$HOME_LOCAL/bin
export LOCAL_LIB_DIR=$HOME/.local/lib
export LOCAL_SHARE_DIR=$HOME/.local/share

export PATH=$LOCAL_BIN_DIR:$PATH

# Rust
[ -d "$HOME/.cargo" ] && [ -f "$HOME/.cargo/env" ] && \. "$HOME/.cargo/env"

# OS specific environment variables
. "$HOME/.config/custom_env/sh.env.local"
