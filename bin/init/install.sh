#!/bin/bash

source ~/dotfiles/lib/env

# aptのインストールスクリプト
if is_apt_available; then
  echo "apt is available on this system"
  ~/dotfiles/bin/init/install_apt.sh
fi

# MacOSのインストールスクリプト
if is_macos; then
  echo "apt is available on this system"
  ~/dotfiles/bin/init/install_mac.sh
fi

# シンボリックリンクを貼る
~/dotfiles/bin/init/symlink.sh