#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

log()     { echo -e "${GREEN}==>${NC} $1"; }
error()   { echo -e "${RED}ERROR:${NC} $1"; exit 1; }
symlink() { local src="$1" dst="$2"; mkdir -p "$(dirname "$dst")"; ln -sf "$src" "$dst" && log "  symlinked: $dst"; }

DOTFILES="$HOME/dotfiles"

###################################################################################################
# Bootstrap: Homebrew + gum
###################################################################################################
if ! command -v brew &>/dev/null; then
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null \
    || eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null
fi

if ! command -v gum &>/dev/null; then
  log "Installing gum..."
  brew install gum
fi

###################################################################################################
# TUI: Component selection
###################################################################################################
echo ""
gum style \
  --border rounded \
  --border-foreground 212 \
  --padding "1 2" \
  --bold \
  "Mac Dotfiles Setup"
echo ""

CHOICES=$(gum choose --no-limit \
  --header "Select components to install (space to toggle, enter to confirm):" \
  --cursor-prefix "[ ] " \
  --selected-prefix "[x] " \
  "zsh       — Zsh + Oh My Zsh + autosuggestions + syntax highlighting" \
  "python    — Python via pyenv + pyenv-virtualenv" \
  "node      — Node.js via nvm (LTS)" \
  "go        — Go via official installer" \
  "rust      — Rust via rustup" \
  "bun       — Bun JavaScript runtime" \
  "neovim    — Neovim + ripgrep" \
  "wezterm   — WezTerm terminal emulator" \
  "tmux      — Tmux terminal multiplexer" \
  "gh        — GitHub CLI" \
  "apps      — Obsidian, OrbStack, Zen Browser" \
  "claude    — Claude Code config symlinks")

if [ -z "$CHOICES" ]; then
  gum style --foreground 196 "No components selected. Exiting."
  exit 0
fi

has() { echo "$CHOICES" | grep -q "^$1"; }

###################################################################################################
# Component: Zsh
###################################################################################################
install_zsh() {
  log "Installing Zsh + Oh My Zsh..."
  brew install zsh zoxide thefuck eza fzf lazygit htop

  # Use the correct zsh path (Apple Silicon vs Intel)
  ZSH_PATH=$(brew --prefix)/bin/zsh
  if ! grep -qF "$ZSH_PATH" /etc/shells; then
    echo "$ZSH_PATH" | sudo tee -a /etc/shells
  fi
  chsh -s "$ZSH_PATH"

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    "" --unattended --keep-zshrc

  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] \
    || git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] \
    || git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

  # fzf shell integration (creates ~/.fzf.zsh sourced in .zshrc)
  "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc

  symlink "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
}

###################################################################################################
# Component: Python
###################################################################################################
install_python() {
  log "Installing Python (pyenv)..."
  brew install pyenv pyenv-virtualenv
}

###################################################################################################
# Component: Node
###################################################################################################
install_node() {
  log "Installing Node.js (nvm)..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm install --lts
}

###################################################################################################
# Component: Neovim
###################################################################################################
install_neovim() {
  log "Installing Neovim + ripgrep..."
  brew install neovim ripgrep
  symlink "$DOTFILES/nvim" "$HOME/.config/nvim"
}

###################################################################################################
# Component: WezTerm
###################################################################################################
install_wezterm() {
  log "Installing WezTerm..."
  brew install --cask wezterm
  symlink "$DOTFILES/wezterm" "$HOME/.config/wezterm"
}

###################################################################################################
# Component: Tmux
###################################################################################################
install_tmux() {
  log "Installing Tmux..."
  brew install tmux
  symlink "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"
}

###################################################################################################
# Component: Go
###################################################################################################
install_go() {
  log "Installing Go..."
  brew install go
}

###################################################################################################
# Component: Rust
###################################################################################################
install_rust() {
  log "Installing Rust (rustup)..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
}

###################################################################################################
# Component: Bun
###################################################################################################
install_bun() {
  log "Installing Bun..."
  curl -fsSL https://bun.sh/install | bash
}

###################################################################################################
# Component: GitHub CLI
###################################################################################################
install_gh() {
  log "Installing GitHub CLI..."
  brew install gh
}

###################################################################################################
# Component: Apps
###################################################################################################
install_apps() {
  log "Installing apps..."
  brew install --cask obsidian orbstack zen-browser
}

###################################################################################################
# Component: Claude Code
###################################################################################################
setup_claude() {
  log "Setting up Claude Code symlinks..."
  mkdir -p "$HOME/.claude"
  symlink "$DOTFILES/claude/settings.json"  "$HOME/.claude/settings.json"
  symlink "$DOTFILES/claude/skills"         "$HOME/.claude/skills"
  [ -d "$DOTFILES/claude/agents" ] \
    && symlink "$DOTFILES/claude/agents"    "$HOME/.claude/agents"
}

###################################################################################################
# Run
###################################################################################################
has "zsh"      && install_zsh
has "python"   && install_python
has "node"     && install_node
has "go"       && install_go
has "rust"     && install_rust
has "bun"      && install_bun
has "neovim"   && install_neovim
has "wezterm"  && install_wezterm
has "tmux"     && install_tmux
has "gh"       && install_gh
has "apps"     && install_apps
has "claude"   && setup_claude

echo ""
gum style --foreground 212 --bold "Setup complete!"
