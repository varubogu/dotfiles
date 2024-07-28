#!/bin/bash

source "$HOME/dotfiles/lib/env"

# XDG_BASE_DIR系の環境変数を読み込む
./xdg_base_dir.sh

# aptのインストールスクリプト
if is_apt_available; then
  echo "apt is available on this system"
  "$HOME/dotfiles/bin/init/install_apt.sh"
fi

# MacOSのインストールスクリプト
if is_macos; then
  echo "apt is available on this system"
  "$HOME/dotfiles/bin/init/install_mac.sh"
fi

# シンボリックリンクを貼る
"$HOME/dotfiles/bin/init/symlink.sh"