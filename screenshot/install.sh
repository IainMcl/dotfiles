#!/usr/bin/env bash
# Sets up the screenshot watcher for the current platform.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
SCRIPT="$DOTFILES/screenshot/screenshot-watch.sh"
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

chmod +x "$SCRIPT"
mkdir -p "$SCREENSHOT_DIR"

case "$(uname -s)" in
  Darwin)
    PLIST_SRC="$DOTFILES/screenshot/com.user.screenshot-watch.plist"
    PLIST_DEST="$HOME/Library/LaunchAgents/com.user.screenshot-watch.plist"

    # Point Screenshot.app at the watched folder
    defaults write com.apple.screencapture location "$SCREENSHOT_DIR"
    killall SystemUIServer 2>/dev/null || true

    # Substitute real paths into the plist template
    sed \
      -e "s|__SCRIPT__|$SCRIPT|g" \
      -e "s|__SCREENSHOTS_DIR__|$SCREENSHOT_DIR|g" \
      "$PLIST_SRC" > "$PLIST_DEST"

    # Reload the agent
    launchctl unload "$PLIST_DEST" 2>/dev/null || true
    launchctl load "$PLIST_DEST"

    echo "macOS: launchd agent loaded."
    echo "Screenshot.app save location → $SCREENSHOT_DIR"
    ;;

  Linux)
    SERVICE_DIR="$HOME/.config/systemd/user"
    SERVICE_DEST="$SERVICE_DIR/screenshot-watch.service"

    # Check required tools
    missing=()
    command -v inotifywait &>/dev/null || missing+=("inotify-tools")
    if [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
      command -v wl-copy &>/dev/null || missing+=("wl-clipboard")
    else
      command -v xclip &>/dev/null || missing+=("xclip")
    fi
    if [[ ${#missing[@]} -gt 0 ]]; then
      echo "Missing packages. Install with:"
      echo "  sudo apt install ${missing[*]}"
      exit 1
    fi

    # Point GNOME Screenshot at the watched folder
    if command -v gsettings &>/dev/null; then
      gsettings set org.gnome.gnome-screenshot auto-save-directory "$SCREENSHOT_DIR" 2>/dev/null || true
    fi

    mkdir -p "$SERVICE_DIR"
    sed "s|__SCRIPT__|$SCRIPT|g" \
      "$DOTFILES/screenshot/screenshot-watch.service" > "$SERVICE_DEST"

    systemctl --user daemon-reload
    systemctl --user enable --now screenshot-watch.service

    echo "Linux: systemd user service enabled and started."
    echo "Screenshot save location → $SCREENSHOT_DIR"
    ;;

  *)
    echo "Unsupported OS: $(uname -s)"
    exit 1
    ;;
esac
