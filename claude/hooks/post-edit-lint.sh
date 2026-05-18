#!/bin/bash
# Run language-appropriate linting/formatting after Claude edits a file.
# Reads a Claude PostToolUse JSON payload from stdin.

file=$(python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    print(d.get('tool_input', {}).get('file_path', ''))
except Exception:
    pass
" 2>/dev/null)

[ -z "$file" ] && exit 0

case "$file" in
  *.py)
    echo "--- ruff ---"
    ruff check --fix "$file"
    ruff format "$file"
    echo "--- mypy ---"
    mypy "$file"
    ;;

  *.tf)
    echo "--- terraform fmt ---"
    terraform fmt "$file"
    echo "--- terraform validate ---"
    terraform validate "$(dirname "$file")"
    ;;

  *.go)
    echo "--- gofmt ---"
    gofmt -w "$file"
    echo "--- go vet ---"
    go vet "$(dirname "$file")/..."
    ;;

  *.js|*.ts|*.tsx|*.jsx|*.mdx)
    command -v prettier &>/dev/null || exit 0
    echo "--- prettier ---"
    prettier --write "$file"
    if command -v eslint &>/dev/null; then
      echo "--- eslint ---"
      eslint --flag unstable_config_lookup_from_file --max-warnings=0 "$file"
    fi
    ;;

  *.rs)
    echo "--- rustfmt ---"
    rustfmt "$file"
    echo "--- cargo clippy ---"
    # clippy needs to run from the crate root
    crate_root=$(dirname "$file")
    while [ "$crate_root" != "/" ] && [ ! -f "$crate_root/Cargo.toml" ]; do
      crate_root=$(dirname "$crate_root")
    done
    [ -f "$crate_root/Cargo.toml" ] && cargo clippy --manifest-path "$crate_root/Cargo.toml" 2>&1
    ;;

  *.css|*.scss)
    command -v stylelint &>/dev/null || exit 0
    echo "--- stylelint ---"
    stylelint --fix "$file"
    ;;
esac

exit 0
