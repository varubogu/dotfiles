#!/bin/zsh

# xcode-selectがインストール済みかどうかをチェック
if xcode-select -p &>/dev/null; then
    echo_log_info "xcode-select is already installed."
else
    echo_log_info "xcode-select is not installed. Starting installation..."
    xcode-select --install
fi

if /usr/bin/pgrep oahd >/dev/null 2>&1; then
    echo_log_info "Rosetta 2 is already installed."
else
    echo_log_info "Rosetta 2 is not installed. Starting installation..."
    /usr/sbin/softwareupdate --install-rosetta --agree-to-license
fi

if [ -f "$HOME/.config/brew/Brewfile" ]; then
    echo_log_info "brew bundle install --file=$HOME/.config/brew/Brewfile"
    brew bundle install --file=$HOME/.config/brew/Brewfile
else
    echo_log_error "Brewfile is not found. Please create it first."
fi

echo_log_info "installing powerline fonts..."
# clone
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts
