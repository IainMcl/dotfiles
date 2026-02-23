#!/usr/bin/env bash
# Status line styled after the oh-my-zsh "refined" theme.
# Layout: <path> <git:branch*> ❯ <model> <ctx%> <cost>

input=$(cat)
cwd=$(echo "$input" | jq -r ".workspace.current_dir")
model=$(echo "$input" | jq -r ".model.display_name")
used=$(echo "$input" | jq -r ".context_window.used_percentage")
remaining=$(echo "$input" | jq -r ".context_window.remaining_percentage")
cost=$(echo "$input" | jq -r ".cost.total_cost_usd")

# Build path and git info
if git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree &>/dev/null; then
  branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null || echo "detached")
  dirty=""
  git -C "$cwd" --no-optional-locks diff --quiet --ignore-submodules HEAD 2>/dev/null || dirty="*"
  git_root=$(git -C "$cwd" --no-optional-locks rev-parse --show-toplevel 2>/dev/null)
  repo_name=$(basename "$git_root")
  rel_path=$(realpath --relative-to="$git_root" "$cwd" 2>/dev/null || echo ".")
  [ "$rel_path" = "." ] && path_display="$repo_name" || path_display="$repo_name/$rel_path"
  path_part=$(printf "\033[1;34m%s\033[0m" "$path_display")
  git_part=$(printf "\033[2mgit:%s%s\033[0m" "$branch" "$dirty")
else
  path_display=$(basename "$cwd")
  path_part=$(printf "\033[1;34m%s\033[0m" "$path_display")
  git_part=""
fi

# Context window info - try percentage fields first, then calculate from tokens
context_part=""
if [ "$used" != "null" ] && [ "$used" != "" ] && [ "$used" != "0" ]; then
  used_int=$(printf "%.0f" "$used")
  remaining_int=$(printf "%.0f" "$remaining")
  context_part=$(printf "\033[2mctx:%s%% (%s%% left)\033[0m" "$used_int" "$remaining_int")
fi

# If we still don't have context info, try calculating from total tokens
if [ -z "$context_part" ]; then
  ctx_size=$(echo "$input" | jq -r ".context_window.context_window_size // empty")
  total_in=$(echo "$input" | jq -r ".context_window.total_input_tokens // empty")
  if [ -n "$ctx_size" ] && [ -n "$total_in" ] && [ "$ctx_size" != "0" ]; then
    pct=$((total_in * 100 / ctx_size))
    rem=$((100 - pct))
    context_part=$(printf "\033[2mctx:%s%% (%s%% left)\033[0m" "$pct" "$rem")
  fi
fi

# Cost info
cost_part=""
if [ "$cost" != "null" ] && [ -n "$cost" ]; then
  cost_part=$(printf "\033[2m\$%.2f\033[0m" "$cost")
fi

# Model name in yellow
model_part=$(printf "\033[33m%s\033[0m" "$model")

# Separator
sep=$(printf "\033[35m❯\033[0m")

# Assemble: path [git] sep model [ctx] [cost]
parts="$path_part"
[ -n "$git_part" ] && parts="$parts $git_part"
parts="$parts $sep $model_part"
[ -n "$context_part" ] && parts="$parts $context_part"
[ -n "$cost_part" ] && parts="$parts $cost_part"

printf "%s" "$parts"
