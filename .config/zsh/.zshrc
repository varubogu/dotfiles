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
    zdharma-continuum/zinit-annex-rust
