#!/bin/bash

. $HOME/.local/lib/functions.bash

echo_log_info "locale to japan ..."
sudo apt-get -y install language-pack-ja

echo_log_info "update-locale LANG=ja_JP.UTF8"
sudo update-locale LANG=ja_JP.UTF8

echo_log_info "timedatectl set-timezone Asia/Tokyo"
sudo timedatectl set-timezone Asia/Tokyo

