# TODO:  auto-suggestions: git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# TODO:  syntax-highlighting: git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# TODO:  zoxide:
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# cargo install zoxide
# TODO: fzf:
# git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
# ~/.fzf/install
# TODO: eza:
# cargo install eza

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

export TERM="xterm-256color"

export EDITOR="nvim"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="awesomepanda"
# ZSH_THEME="nicoulaj
ZSH_THEME="refined"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    history
    encode64
    copypath
    # zsh-autosuggestions
    # zsh-syntax-highlighting
    web-search
    # alias-finder
    aws
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ls="eza --icons=always"

# -------- Zoxide (better cd) --------
eval "$(zoxide init zsh)"
alias cd="z"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

###########
# Path
###########

export PATH="$PATH:~/.local/bin"

###########
# User config
###########

unsetopt BEEP
unsetopt correct # Stop correction confirmation

# Enable fuzzy completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# Search history
# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward


###########
# Aliases
# #########

# MISC
alias vim="nvim"
alias vi="nvim"
alias tm="tmux"
alias cls="clear"
alias lg="lazygit"

# Ls
alias la="ls -la"
alias ll="ls -l"
alias l="ls -CF"

# git
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit --all -m"
alias gp="git push"
alias gpl="git pull"
alias gco="git checkout"
alias gb="git branch"
alias gb="git branch"
alias gaa="git add --all"
alias gclean="git reset --hard && git clean -dfx"
alias glog="git log --oneline --decorate --all --graph"

# system
alias top="htop"

# docker
alias d="docker"
alias dc="docker-compose"

# quick open
alias zshrc="$EDITOR ~/.zshrc"
alias hosts="$EDITOR /etc/hosts"
alias vimrc="$EDITOR ~/.config/nvim/init.lua"


# git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
# ~/.fzf/install

# Add this to .zshrc
if ! zle -la | grep -q fzf-history-widget; then
  autoload -Uz fzf-history-widget
  zle -N fzf-history-widget
  bindkey '^R' fzf-history-widget
fi

fzf_cd() {
  local dir
  dir=$(find . -type d -print | fzf)
  if [[ -n "$dir" ]]; then
    cd "$dir"
  fi
}

zle -N fzf_cd

# Bind the function to Ctrl+F
bindkey '^F' fzf_cd

# The fuck
eval $(thefuck --alias)

##############
## Obsidian
##############

export VAULTS_PATH="$HOME/notes/hitchhiker/"
alias oo='cd $VAULTS_PATH && $VAULTS_PATH && nvim'
export PATH=$PATH:$HOME/dotfiles/zsh/bin


# if [ -x "$SSH_AUTH_SOCK" ] || ! pgrep -u "$USER" ssh-agent > /dev/null; then
#     eval "$(ssh-agent -s)"
# fi
#
# if ! ssh-add -l | grep -q '/home/iainm/.ssh/smart'; then
#     ssh-add /home/iainm/.ssh/smart
# fi

# Start the SSH agent if not already running
# if ! pgrep -u "$USER" ssh-agent > /dev/null; then
#     eval "$(ssh-agent -s)"
# fi
#
# # Add the SSH key to the agent if not already added
# ssh-add -l | grep -q '/home/iainm/.ssh/smart' || ssh-add /home/iainm/.ssh/smart

# source $HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

####
# TK specific
####

export PATH="$PATH:$HOME/.local/bin"
# Export Codeartifact auth (generated by 'tk login')
[ -f "$HOME/.config/pip/pip.conf" ] && export PIP_INDEX_URL=$(awk -F "= " '/index-url/ {print $2}' $HOME/.config/pip/pip.conf) && export UV_INDEX_URL=$PIP_INDEX_URL

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# This should maybe do in .zprofile
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
export PATH="/usr/local/opt/libqp/bin:$PATH"
