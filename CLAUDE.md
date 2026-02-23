# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles repository for a WSL Ubuntu development environment, primarily using Wezterm, Neovim, tmux, and zsh. Configured for Python, Go, and JavaScript/TypeScript development with Obsidian note-taking integration.

## Repository Structure

- `nvim/` — Neovim configuration (Lua-based, uses Lazy package manager)
  - `nvim/lua/iainm/` — Core config modules (keymaps, settings, theme, etc.)
  - `nvim/lua/iainm/lazy/` — Individual plugin configurations (one file per plugin)
  - Entry point: `nvim/init.lua` → `nvim/lua/iainm/init.lua` → `nvim/lua/iainm/lazy_init.lua`
- `wezterm/` — Wezterm terminal config (Lua-based, modular)
  - `wezterm/wezterm.lua` — Entry point
  - `wezterm/config/` — Appearance, keybindings, init
  - `wezterm/utils/` — Platform detection utilities
- `claude/` — Claude Code configuration (rules, skills, settings)
  - `claude/rules/` — Behavioral rules loaded as global instructions
  - `claude/skills/` — Custom skills (commit-code, create-draft-pr, address-pr-comments, coding-task, jira-cli)
- `zsh/` — Zsh config (`.zshrc`) and helper scripts in `zsh/bin/`
- `fish/` — Fish shell config
- `tmux/` — Tmux configuration
- `powershell/` — PowerShell profile with Oh My Posh theme
- `MacInstall/` / `WindowsInstall/` — Platform-specific install scripts (not well tested)

## Key Conventions

- **Neovim plugins**: Each plugin gets its own file in `nvim/lua/iainm/lazy/`, returning a Lazy plugin spec table. Follow the existing pattern when adding new plugins.
- **Wezterm config**: Modular structure — appearance in `config/appearence.lua`, keybindings in `config/keys.lua`. Platform-specific logic via `utils/platform.lua`.
- **Claude skills**: Each skill lives in `claude/skills/<name>/SKILL.md`. Skills define reusable workflows for Claude Code.
- **Claude rules**: Markdown files in `claude/rules/` are loaded as global instructions across all projects.

## Working with This Repository

There are no build steps, tests, or linters for this repository. Changes are validated by loading the configs in their respective tools (Neovim, Wezterm, tmux, etc.).

Symlinks or copies are used to place these configs in their expected locations (e.g., `~/.config/nvim/`, `~/.tmux.conf`). The install scripts in `MacInstall/` and `WindowsInstall/` handle initial setup but are not regularly maintained.
