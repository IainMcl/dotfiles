# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Key Conventions

- **Neovim plugins**: Each plugin gets its own file in `nvim/lua/iainm/lazy/`, returning a Lazy plugin spec table. Follow the existing pattern when adding new plugins.
- **Wezterm config**: Modular structure — appearance in `config/appearence.lua`, keybindings in `config/keys.lua`. Platform-specific logic via `utils/platform.lua`.
- **Claude skills**: Each skill lives in `claude/skills/<name>/SKILL.md`. Skills define reusable workflows for Claude Code.

## Working with This Repository

There are no build steps, tests, or linters for this repository. Changes are validated by loading the configs in their respective tools (Neovim, Wezterm, tmux, etc.).

Symlinks or copies are used to place these configs in their expected locations (e.g., `~/.config/nvim/`, `~/.tmux.conf`). The install scripts in `MacInstall/` and `WindowsInstall/` handle initial setup but are not regularly maintained.
