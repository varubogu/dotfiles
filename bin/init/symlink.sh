#!/bin/zsh

DOTCONFIG=$HOME/dotfiles/.config

ln -s $DOTCONFIG/.bash/.bashrc ~/.bashrc
ln -s $DOTCONFIG/.bash/.bash_profile ~/.bash_profile
ln -s $DOTCONFIG/.zsh/.zshrc ~/.zshrc
ln -s $DOTCONFIG/.zsh/.zprofile ~/.zprofile
ln -s $DOTCONFIG/.zsh/.zshrc.lazy ~/.zshrc.lazy
