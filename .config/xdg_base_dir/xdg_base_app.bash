#!/bin/bash

# XDG Base Configuration
export SSH_CONFIG=$XDG_CONFIG_HOME/ssh
export GNUPGHOME=$XDG_CONFIG_HOME/gnupg

# bash
export BASH_CONFIG=$XDG_CONFIG_HOME/bash
export BASH_DATA_HOME=$XDG_DATA_HOME/bash
export BASH_LOG_DIR=$BASH_DATA_HOME/log
export BASH_PLUGIN_DIR=$BASH_DATA_HOME/plugins
export BASH_THEME_DIR=$BASH_DATA_HOME/themes
export BASH_HISTORY_DIR=$BASH_DATA_HOME/history
export BASH_HISTFILE=$BASH_HISTORY_DIR/histfile
export BASH_HISTSIZE=1000
export BASH_SAVEHIST=1000
export BASH_CACHE_DIR=$XDG_CACHE_HOME/bash

# ZSH
export ZDOTDIR=$XDG_CONFIG_HOME/zsh
export ZSH_DATA_HOME=$XDG_DATA_HOME/zsh
export ZSH_HISTORY=$ZSH_DATA_HOME/history
export ZSH_HISTFILE=$ZSH_HISTORY/histfile
export ZSH_HISTSIZE=1000
export ZSH_SAVEHIST=1000
export ZSH_LOG_DIR=$ZSH_DATA_HOME/log
export ZSH_PLUGIN_DIR=$ZSH_DATA_HOME/plugins
export ZSH_THEME_DIR=$ZSH_DATA_HOME/themes
export ZSH_CACHE_DIR=$XDG_CACHE_HOME/zsh


current_shell=$SHELL
case "$current_shell" in
    *zsh)
        echo "active zsh"
        export HISTFILE="$ZSH_HISTFILE"
        export HISTSIZE="$ZSH_HISTSIZE"
        export SAVEHIST="$ZSH_SAVEHIST"
        ;;
    *bash)
        echo "active bash"
        export HISTFILE="$BASH_HISTFILE"
        export HISTSIZE="$BASH_HISTSIZE"
        # not found in bash
        # export SAVEHIST="$BASH_SAVEHIST"
        ;;
    *)
        echo "Unknown shell: $current_shell"
        exit 1
        ;;
esac
