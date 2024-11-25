# Common environment
if [ -r "$HOME/.config/custom_env/common.rc" ]; then
    . $HOME/.config/custom_env/common.rc
else
    echo "Common environment is not found. Please create it first."
fi

# OS specific environment
if [ -r "$HOME/.config/custom_env/os.rc" ]; then
    . $HOME/.config/custom_env/os.rc
else
    echo "OS specific environment is not found. Please create it first."
fi

# Starship
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
else
    echo "Starship is not installed. Please install it first."
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust \
    zsh-users/zsh-syntax-highlighting \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-completions \
    zdharma/history-search-multi-word

# 自動保管
#autoload -U compinit; compinit

# <directory path> only -> cd <directory path>
# .. -> cd ..
# /usr/bin -> cd /usr/bin
setopt auto_cd

# cd alias
alias ...='cd ../..'
alias ....='cd ../../..'

# When entering a command, delete old identical commands from the command history
setopt hist_ignore_all_dups

# match big <--> little
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# completion menu select
zstyle ':completion:*:default' menu select=2

# directory completion to add '/'
setopt auto_param_slash

# カッコを自動補完
setopt auto_param_keys

# commandline args completion --prefix=/usr/bin  <- '/usr/bin'
setopt magic_equal_subst

# utf8 name view
setopt print_eight_bit

# If it starts with a space, no history is added
setopt hist_ignore_space


# pyshell_venv
pysh(){
    HOST_PYTHON_COMMAND="python"
    if [ command -v python3 &> /dev/null ]; then
        HOST_PYTHON_COMMAND="python3"
    fi
    if [ ! -d "$HOME/.local/share/pyshell_venv" ]; then
        $HOST_PYTHON_COMMAND -m venv "$HOME/.local/share/pyshell_venv"
    fi
    if [ -d "$HOME/.local/share/pyshell_venv" ]; then
        source "$HOME/.local/share/pyshell_venv/bin/activate"
    else
        echo "pyshell_venv is not found."
    fi
}
