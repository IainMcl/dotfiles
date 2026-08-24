#!/bin/bash
# Stop hook: speaks Claude's last response via macOS `say`, for accessibility
# (dyslexia) readback. Full response still renders normally in the terminal -
# this is purely an additional audio channel, so it reads the whole thing
# (cleaned of code/markdown/paths), not a truncated summary - a cut-off
# readback just recreates the reading problem for whatever got dropped.

VOICE="Samantha"
RATE="250"
MAX_CHARS=5000  # runaway-safety cap only, not a "keep it short" cap
DISABLE_FLAG="$HOME/.claude/speak-summary.disabled"

[ -f "$DISABLE_FLAG" ] && exit 0

input=$(cat)
transcript_path=$(echo "$input" | jq -r '.transcript_path // empty')

# The transcript write can lag slightly behind the Stop event firing;
# without this, we sometimes read the previous turn's final text instead.
sleep 0.5

[ -z "$transcript_path" ] && exit 0
[ ! -f "$transcript_path" ] && exit 0

# Last text block Claude produced, in true chronological order. A single
# assistant turn can contain several text blocks around tool calls (e.g.
# "let me check that" -> tool_use -> final answer) - only the very last one
# is the actual response, so take `last`, not `first` off a reversed read.
last_text=$(jq -s -r '
  [.[] | select(.type == "assistant") |
   .message.content[]? |
   select(.type == "text") |
   .text] | last // empty
' "$transcript_path" 2>/dev/null)

[ -z "$last_text" ] && exit 0

summary=$(printf '%s' "$last_text" | perl -0777 -pe '
  s/```.*?```//gs;                # fenced code blocks
  s/`[^`]*`//g;                   # inline code
  s/\[([^\]]*)\]\([^)]*\)/$1/g;   # markdown links -> link text
  s{(/[\w.\-]+)+\.\w+}{}g;        # file paths
  s/^#+\s*//gm;                   # headers
  s/^[\s*\-]+//gm;                # list bullets
  s/\*\*?([^*]+)\*\*?/$1/g;       # bold/italic markers
  s/\s+/ /g;                      # collapse whitespace
' | sed -E 's/^ +| +$//g')

# Cap at MAX_CHARS (safety net for runaway responses only), trimmed back to
# the last whole word.
short="${summary:0:$MAX_CHARS}"
if [ "${#summary}" -gt "$MAX_CHARS" ]; then
  short="${short% *}"
fi

[ -z "$short" ] && exit 0

# Stop any in-flight readback first - otherwise a new response starting to
# speak before the previous one finishes overlaps into jumbled audio.
pkill -x say 2>/dev/null

say -v "$VOICE" -r "$RATE" "$short" >/dev/null 2>&1 &
disown
exit 0
