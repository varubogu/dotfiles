#!/bin/bash

. $HOME/dotfiles/.local/bin/lib/env_os.sh
. $HOME/dotfiles/.local/bin/lib/command.sh

echo "install os specific packages"

if is_mac; then
    echo "apt is available on this system"
    ./install_mac.sh
fi

if is_command_available apt; then
    echo "apt is available on this system"
    ./install_apt.sh
fi



# シンボリックリンクを貼る
"$HOME/dotfiles/bin/init/symlink.sh"