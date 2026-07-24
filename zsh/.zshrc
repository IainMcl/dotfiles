# OPENSPEC:START
# OpenSpec shell completions configuration - fpath must be set before compinit
fpath=("$HOME/.oh-my-zsh/custom/completions" $fpath)
# OPENSPEC:END

###########
# Core env
###########

export TERM="xterm-256color"
export EDITOR="nvim"
export WORK_HOST="TK-H3H4FMFPC2"
export PERSONAL_HOST="pop-os"

###########
# Path
###########

export PATH="$PATH:~/.local/bin/"
export PATH="$PATH:~/.cargo/bin/"
export PATH="$PATH:/home/iainmclaughlan/.cargo/bin"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$HOME/dotfiles/zsh/bin:$PATH"

if [[ "$(hostname)" == "$PERSONAL_HOST" ]]; then
    export PATH="$PATH:/home/iainmclaughlan/src/Todo.go/bin"
fi

###########
# Completions
###########

autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit -u
else
    compinit -uC
fi

###########
# History
###########

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt APPEND_HISTORY

###########
# Options
###########

unsetopt BEEP
unsetopt correct
DISABLE_MAGIC_FUNCTIONS=true
CASE_SENSITIVE=true

###########
# Plugins (via homebrew)
###########

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

###########
# Prompt (starship)
###########

eval "$(starship init zsh)"

###########
# Key bindings
###########

bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Arrow keys - character and word movement
bindkey '\eOD' backward-char
bindkey '\eOC' forward-char
bindkey '\e[1;5D' backward-word
bindkey '\e[1;5C' forward-word

###########
# Tools
###########

# Zoxide (better cd)
eval "$(zoxide init zsh)"
alias cd="z"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fzf history widget
if ! zle -la | grep -q fzf-history-widget; then
    autoload -Uz fzf-history-widget
    zle -N fzf-history-widget
    bindkey '^R' fzf-history-widget
fi

# fzf cd
fzf_cd() {
    local dir
    dir=$(find . -type d -print | fzf)
    if [[ -n "$dir" ]]; then
        cd "$dir"
    fi
}
zle -N fzf_cd
bindkey '^F' fzf_cd

# Lazy-load NVM
export NVM_DIR="$HOME/.nvm"
nvm() {
    unfunction nvm node npm npx 2>/dev/null
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm "$@"
}
node() { nvm; node "$@"; }
npm()  { nvm; npm  "$@"; }
npx()  { nvm; npx  "$@"; }

# Lazy-load thefuck
fuck() {
    unfunction fuck
    eval "$(thefuck --alias fuck)"
    fuck "$@"
}

###########
# Python
###########

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# Remove stale rehash lock if present
[[ -f "$PYENV_ROOT/shims/.pyenv-shim" ]] && rm -f "$PYENV_ROOT/shims/.pyenv-shim"
_pyenv_cache="${HOME}/.cache/pyenv_init.zsh"
if [[ ! -f "$_pyenv_cache" || -z "$(find "$_pyenv_cache" -mmin -10080 2>/dev/null)" ]]; then
    mkdir -p "${HOME}/.cache"
    pyenv init - > "$_pyenv_cache"
fi
source "$_pyenv_cache"
unset _pyenv_cache

###########
# Aliases
###########

# Misc
alias cld="claude --dangerously-skip-permissions"
alias vim="nvim"
alias vi="nvim"
alias tm="tmux"
alias cls="clear"
alias lg="lazygit"

# ls
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

###########
# Utilities
###########

uuid() {
    local uuid=$(uuidgen | awk '{print tolower($0)}' | tr -d '\n')
    echo $uuid | pbcopy
    echo $uuid
}

###########
# Obsidian
###########

if [[ "$(hostname)" == "$WORK_HOST" ]]; then
    export VAULTS_PATH="$HOME/notes/hitchhiker/"
else
    export VAULTS_PATH="$HOME/notes/hitchhiker/"
fi
alias oo='cd $VAULTS_PATH && nvim'

###########
# TK specific
###########

if [[ "$(hostname)" == "$WORK_HOST" ]]; then
    [ -f "$HOME/.config/pip/pip.conf" ] && export PIP_INDEX_URL=$(awk -F "= " '/index-url/ {print $2}' $HOME/.config/pip/pip.conf) && export UV_INDEX_URL=$PIP_INDEX_URL

    # NVM via homebrew
    nvm() {
        unfunction nvm node npm npx 2>/dev/null
        [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
        [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
        nvm "$@"
    }
    node() { nvm; node "$@"; }
    npm()  { nvm; npm  "$@"; }
    npx()  { nvm; npx  "$@"; }

    _tk_cache="${HOME}/.cache/tk_shell_setup.zsh"
    if [[ ! -f "$_tk_cache" ]]; then
        mkdir -p "${HOME}/.cache"
        tk shell-setup > "$_tk_cache"
    fi
    source "$_tk_cache"
    unset _tk_cache

    export PATH="/usr/local/opt/libqp/bin:$PATH"

    test_backend() {
        local log_level="--log-cli-level=WARN"
        local test=""
        if [[ "$#" -eq 2 ]]; then
            log_level="--log-cli-level=$1"
            test=$2
        elif [[ "$#" -eq 1 ]]; then
            test=$1
        else
            echo "Usage:"
            echo "    test_backend [LOG_LEVEL] test"
            echo "Where:"
            echo "    [LOG_LEVEL] - optional log level value, DEBUG, INFO, WARN, ERROR"
            echo "    test        - path to the test file to be run and optionally test"
            echo "Example:"
            echo "    test_backend payments/services/tests/test_vcc_provider_benefit_service.py"
            echo "    test_backend DEBUG payments/services/tests/test_vcc_provider_benefit_service.py"
            echo "    test_backend DEBUG payments/services/tests/test_vcc_provider_benefit_service.py::VCCProviderPreferenceTestCase"
            return
        fi
        if [[ "$test" == travelperk/* ]]; then
            test="${test#travelperk/}"
        fi
        docker compose run -e DJANGO_CONFIGURATION=Test --rm django scripts/tools/run-tests.sh -vv --create-db "$log_level" "$test"
    }
fi

alias tkl="tk login && export AWS_PROFILE=tooling"

###########
# Local config (secrets etc.)
###########

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

###########
# Terminal integrations
###########

# WezTerm shell integration - CWD tracking for tab titles
[[ -n "$WEZTERM_PANE" && -f /Applications/WezTerm.app/Contents/Resources/wezterm.sh ]] && source /Applications/WezTerm.app/Contents/Resources/wezterm.sh

[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

###########
# bun
###########

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "/Users/iainmclaughlan/.bun/_bun" ] && source "/Users/iainmclaughlan/.bun/_bun"

###########
# pnpm
###########

export PNPM_HOME="/Users/iain.mclaughlan/Library/pnpm"
case ":$PATH:" in
    *":$PNPM_HOME/bin:"*) ;;
    *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac

###########
# PostgreSQL
###########

export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
