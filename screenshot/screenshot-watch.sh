#!/usr/bin/env bash
# On macOS: called once per launchd WatchPaths event; exits after handling.
# On Linux: runs as a persistent daemon using inotifywait.

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
DEST="/tmp/screenshot.png"

handle() {
  local newest
  newest=$(ls -t "$SCREENSHOT_DIR"/*.png 2>/dev/null | head -1) || return 0
  [[ -z "$newest" ]] && return 0
  # Skip if dest is already up to date
  [[ -f "$DEST" && "$DEST" -nt "$newest" ]] && return 0

  cp "$newest" "$DEST"

  case "$(uname -s)" in
    Darwin)
      osascript -e "set the clipboard to (read (POSIX file \"$DEST\") as «class PNGf»)"
      ;;
    Linux)
      if [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
        wl-copy --type image/png < "$DEST"
      else
        xclip -selection clipboard -t image/png -i "$DEST"
      fi
      ;;
  esac
}

if [[ "$(uname -s)" == "Linux" ]]; then
  mkdir -p "$SCREENSHOT_DIR"
  while inotifywait -e close_write,moved_to --include '\.png$' -q "$SCREENSHOT_DIR"; do
    handle || true
  done
else
  handle
fi
