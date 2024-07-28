# XDG Base Configuration
export SSH_CONFIG=$XDG_CONFIG_HOME/ssh
export GNUPGHOME=$XDG_CONFIG_HOME/gnupg

# bash
export BASH_CONFIG=$XDG_CONFIG_HOME/bash
export BASH_HISTORY=$BASH_DATA_HOME/history
export BASH_HISTFILE=$BASH_HISTORY/histfile
export BASH_HISTSIZE=1000
export BASH_SAVEHIST=1000
export BASH_CACHE_DIR=$XDG_CACHE_HOME/bash
export BASH_LOG_DIR=$XDG_DATA_HOME/bash/log
export BASH_DATA_HOME=$XDG_DATA_HOME/bash
export BASH_PLUGIN_DIR=$BASH_DATA_HOME/plugins
export BASH_THEME_DIR=$BASH_DATA_HOME/themes

# ZSH
export ZDOTDIR=$XDG_CONFIG_HOME/zsh
export ZSH_CACHE_DIR=$XDG_CACHE_HOME/zsh
export ZSH_DATA_HOME=$XDG_DATA_HOME/zsh
export ZSH_HISTORY=$ZSH_DATA_HOME/history
export ZSH_HISTFILE=$ZSH_HISTORY/histfile
export ZSH_HISTSIZE=1000
export ZSH_SAVEHIST=1000
export ZSH_LOG_DIR=$ZSH_DATA_HOME/log
export ZSH_PLUGIN_DIR=$ZSH_DATA_HOME/plugins
export ZSH_THEME_DIR=$ZSH_DATA_HOME/themes


current_shell=$(ps -p $$ -o args=)
if [[ $current_shell == "*zsh" ]]; then
    export HISTFILE=$ZSH_HISTFILE
    export HISTSIZE=$ZSH_HISTSIZE
    export SAVEHIST=$ZSH_SAVEHIST
elif [[ $current_shell == "*bash" ]]; then
    export HISTFILE=$BASH_HISTFILE
    export HISTSIZE=$BASH_HISTSIZE
    export SAVEHIST=$BASH_SAVEHIST
fi

