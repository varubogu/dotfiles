#!/bin/bash

. $HOME/.local/bin/lib/functions.bash

echo_log_info "locale to japan ..."

sudo update-locale LANG=ja_JP.UTF8
sudo timedatectl set-timezone Asia/Tokyo

