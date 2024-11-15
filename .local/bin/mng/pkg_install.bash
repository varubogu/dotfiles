#!/bin/bash

. $HOME/.local/bin/lib/functions.bash

if is_command_available brew; then
    echo_log_info "brew bundle install --file $DOTCONFIG/brew/Brewfile"
    brew bundle install --file $DOTCONFIG/brew/Brewfile
fi
