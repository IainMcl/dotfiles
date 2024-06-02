#!/bin/bash

###### 
# Ubuntu setup 
###### 

# Update package list
apt update

# Neovim 
apt install -y neovim 

# Remove existing Neovim configuration if it exists
if [ -d ~/.config/nvim ]; then
    rm -rf ~/.config/nvim
fi

# Create symlink for Neovim configuration
ln -s ~/dotfiles/nvim/ ~/.config/nvim 

# Fish shell 
apt install -y fish 

# Remove existing Fish shell configuration if it exists
if [ -d ~/.config/fish ]; then
    rm -rf ~/.config/fish
fi

# Create symlink for Fish shell configuration
ln -s ~/dotfiles/fish/ ~/.config/fish 

# Tmux 
apt install -y tmux 

# Remove existing Tmux configuration if it exists
if [ -f ~/.tmux.conf ]; then
    rm ~/.tmux.conf
fi

# Create symlink for Tmux configuration
ln -s ~/dotfiles/tmux/tmux.conf ~/.tmux.conf

