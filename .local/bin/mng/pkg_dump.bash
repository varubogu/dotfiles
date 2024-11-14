#!/bin/bash

. $HOME/.local/bin/lib/functions.bash

if is_command_available brew; then
    brew bundle dump --global --force
fi
