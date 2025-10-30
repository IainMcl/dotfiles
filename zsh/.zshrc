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

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

export TERM="xterm-256color"

export EDITOR="nvim"
# export WORK_HOST="TK3695"
export WORK_HOST="TK-H3H4FMFPC2"
export PERSONAL_HOST="pop-os"

###########
# Path
###########

export PATH="$PATH:~/.local/bin/"
export PATH="$PATH:/opt/nvim/"
export PATH="$PATH:~/.cargo/bin/"
export PATH="$PATH:/home/iainmclaughlan/.cargo/bin"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/.local/bin"

if [[ "$(hostname)" == "$PERSONAL_HOST" ]]; then
    export PATH="$PATH:/home/iainmclaughlan/src/Todo.go/bin"
fi

# Local config file. This contains things like secrets
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

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

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    history
    encode64
    copypath
    zsh-autosuggestions
    zsh-syntax-highlighting
    web-search
    aws
)

source $ZSH/oh-my-zsh.sh


# -------- Zoxide (better cd) --------
eval "$(zoxide init zsh)"
alias cd="z"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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

# Word-by-word navigation
# Ctrl+LeftArrow
bindkey '^[[D' backward-word
# Ctrl+RightArrow
bindkey '^[[C' forward-word

###########
# Aliases
# #########

# MISC
alias vim="nvim"
alias vi="nvim"
alias tm="tmux"
alias cls="clear"
alias lg="lazygit"
alias bat="batcat"

# Ls
alias ls="eza --icons=always"
alias la="ls -la"
alias ll="ls -l"

# git
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit --all -m"
alias gca="git commit --all -m"
alias gp="git push"
alias gpl="git pull"
alias gf="git fetch"
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

if [[ "$(hostname)" == "$WORK_HOST" ]]; then
    export VAULTS_PATH="$HOME/notes/hitchhiker/"
else
    export VAULTS_PATH="$HOME/notes/hitchhiker/"
fi
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
# source $HOME/zsh-autosuggestions/zsh-autosuggestions.zsh

# source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

uuid() {
    local uuid=$(uuidgen | awk '{print tolower($0)}' | tr -d '\n')
    echo $uuid | pbcopy
    echo $uuid
}


####
# Python
####

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

eval "$(pyenv virtualenv-init -)"

####
# TK specific
####

if [[ "$(hostname)" == "$WORK_HOST" ]]; then
    # Export Codeartifact auth (generated by 'tk login')
    [ -f "$HOME/.config/pip/pip.conf" ] && export PIP_INDEX_URL=$(awk -F "= " '/index-url/ {print $2}' $HOME/.config/pip/pip.conf) && export UV_INDEX_URL=$PIP_INDEX_URL

    export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

    eval $(tk shell-setup)
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"

    # This should maybe do in .zprofile
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    export PATH="/usr/local/opt/libqp/bin:$PATH"

    test_backend () {
        # cd ~/src/backend
        # Default to WARN errors
        local log_level="--log-cli-level=WARN"
        local test=""

        if [[ "$#" -eq 2 ]]
        then
            log_level="--log-cli-level=$1"
            test=$2
        elif [[ "$#" -eq 1 ]]
        then
            test=$1
        else
            echo "Usage:"
            echo "    test_backend [LOG_LEVEL] test"
            echo "Where:"
            echo "    [LOG_LEVEL] - optional log level value, DEBUG, INFO, WARN, ERROR"
            echo "    test        - path to the test file to be run and optionally test"
            echo "Example:"
            echo "    test_backend payments/services/tests/test_vcc_provider_preference_service.py"
            echo "    test_backend DEBUG payments/services/tests/test_vcc_provider_preference_service.py"
            echo "    test_backend DEBUG payments/services/tests/test_vcc_provider_preference_service.py::VCCProviderPreferenceTestCase"
            return
        fi
        # Strip 'travelperk/' prefix if present
        if [[ "$test" == travelperk/* ]]; then
            test="${test#travelperk/}"
        fi
        # DJANGO_CONFIGURATION=test docker compose run --rm django scripts/tools/run-tests.sh -vv --create-db "$log_level" "$test"
        docker compose run -e DJANGO_CONFIGURATION=Test --rm django scripts/tools/run-tests.sh -vv --create-db "$log_level" "$test"
    }
fi

alias tkl="tk login && export AWS_PROFILE=tooling"

. "$HOME/.local/bin/env"
