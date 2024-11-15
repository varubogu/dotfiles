#!/bin/zsh

# xcode-selectがインストール済みかどうかをチェック
if xcode-select -p &>/dev/null; then
    echo "xcode-select is already installed."
else
    echo "xcode-select is not installed. Starting installation..."
    xcode-select --install
fi

if /usr/bin/pgrep oahd >/dev/null 2>&1; then
    echo "Rosetta 2 is already installed."
else
    echo "Rosetta 2 is not installed. Starting installation..."
    /usr/sbin/softwareupdate --install-rosetta --agree-to-license
fi

if [ -f "$HOME/.config/brew/Brewfile" ]; then
    brew bundle install --file=$HOME/.config/brew/Brewfile
else
    echo "Brewfile is not found. Please create it first."
fi

