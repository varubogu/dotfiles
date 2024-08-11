#!/bin/bash

. $HOME/dotfiles/.local/bin/lib/env_os.sh
. $HOME/dotfiles/.local/bin/lib/command.sh

echo "install os specific packages"

INSTALL_SCRIPTS_DIR="$HOME/dotfiles/.local/bin/init"

if is_mac; then
    echo "apt is available on this system"
    . $INSTALL_SCRIPTS_DIR/install_mac.sh
fi

if is_command_available apt; then
    echo "apt is available on this system"
    . $INSTALL_SCRIPTS_DIR/install_apt.sh
fi



# シンボリックリンクを貼る
. $INSTALL_SCRIPTS_DIR/symlink.sh