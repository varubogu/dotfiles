#!/bin/bash

. ~/.local/bin/lib/command.bash

if is_command_available brew; then
    brew bundle dump --global --force
fi
