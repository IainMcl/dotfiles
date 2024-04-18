###################################################################################################
# Brew
###################################################################################################
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


###################################################################################################
# Fish
###################################################################################################

# brew install fish

brew install zsh
chsh -s /usr/loca/bin/zsh

# install om my zsh

# brew install zsh-autosuggestions
# brew instal zsh-syntax-highlighting

# iTerm2
brew install iterm2 --cask

# Nerd fonts

bres tap homebrew/cask-fonts
brew isntall --cask font-hack-nerd-font

brew install neovim

# Creating symlinks
# ln -s /path/to/original /path/to/link

# Create Neovim link
ln -s ~/dotfiles/nvim/ ~/.config/

# Fish shell
brew install fish
ln -s ~/dotfiles/fish/ ~/.config/

# Tmux
brew install tmux
ln -s ~/dotfiles/tmux/* ~/.tmux
