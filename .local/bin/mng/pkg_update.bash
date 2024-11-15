#!/bin/bash

. $HOME/.local/bin/lib/functions.bash

# use brew
if is_command_available brew; then
  echo_log_info "brew update && brew upgrade"
  brew update && brew upgrade
fi

# use apt-get
if is_command_available apt-get; then
  echo_log_info "sudo apt-get update && sudo apt-get upgrade -y"
  sudo apt-get update && sudo apt-get upgrade -y
fi

# use snap
if is_command_available snap; then
  echo_log_info "sudo snap refresh"
  sudo snap refresh
fi

if is_command_available pacman; then
  echo_log_info "sudo pacman -Syu"
  sudo pacman -Syu
fi

# use yum
if is_command_available yum; then
  echo_log_info "sudo yum update -y"
  sudo yum update -y
fi

# use npm
if is_command_available npm; then
  echo_log_info "npm update -g"
  npm update -g
fi

# use yarn
if is_command_available yarn; then
  echo_log_info "yarn global upgrade"
  yarn global upgrade
fi

# use pnpm
if is_command_available pnpm; then
  echo_log_info "pnpm update -g"
  pnpm update -g
fi

# use bun
if is_command_available bun; then
  echo_log_info "bun update"
  bun update
fi

# use composer
if is_command_available composer; then
  echo_log_info "composer self-update"
  composer self-update
  echo_log_info "composer global update"
  composer global update
fi

# use gem
if is_command_available gem; then
  echo_log_info "gem update"
  gem update
fi

# use pip
if is_command_available pip; then
  echo_log_info "pip install --upgrade pip"
  pip install --upgrade pip
  echo_log_info "pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U"
  pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U
fi
