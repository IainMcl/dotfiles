#!/bin/bash

###################################################################################################
# Brew
###################################################################################################
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

###################################################################################################
# Zsh & Oh My Zsh
###################################################################################################
brew install zsh
chsh -s /usr/local/bin/zsh

# Install Oh My Zsh (keeps existing .zshrc)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

# Oh My Zsh custom plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Zsh tools
brew install zoxide thefuck eza

###################################################################################################
# Python (pyenv)
###################################################################################################
brew install pyenv pyenv-virtualenv

###################################################################################################
# Node (nvm)
###################################################################################################
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install --lts

###################################################################################################
# Neovim
###################################################################################################
brew install neovim

###################################################################################################
# WezTerm
###################################################################################################
brew install --cask wezterm

###################################################################################################
# Symlinks
###################################################################################################
mkdir -p ~/.config

# Neovim
ln -s ~/dotfiles/nvim ~/.config/nvim

# WezTerm
ln -s ~/dotfiles/wezterm ~/.config/wezterm

# Zsh
ln -s ~/dotfiles/zsh/.zshrc ~/.zshrc

# Claude Code
ln -s ~/dotfiles/claude/settings.json ~/.claude/settings.json
ln -s ~/dotfiles/claude/skills ~/.claude/skills
ln -s ~/dotfiles/claude/agents ~/.claude/agents

# Fish shell (optional)
# brew install fish
# ln -s ~/dotfiles/fish ~/.config/fish

# Tmux (optional)
# brew install tmux
# ln -s ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
