#!/bin/zsh

echo "installing Xcode..."
xcode-select --install

echo "installing Rosetta..."
sudo softwareupdate --install-rosetta --agree-to-licensesudo softwareupdate --install-rosetta --agree-to-license

echo "installing HomeBrew..."
sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
