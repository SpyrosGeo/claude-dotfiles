#!/usr/bin/env bash
# Symlink tracked Claude Code config into ~/.claude. Re-runnable; an existing real file is moved to <name>.bak.
set -euo pipefail
src="$(cd "$(dirname "$0")" && pwd)"
dst="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
paths=(
  settings.json
  CLAUDE.md
  statusline-command.sh
  ask-settings.json
  agents/ask.md
  hooks/caveman-statusline.sh
  skills/graphify
  skills/review-code
)
for p in "${paths[@]}"; do
  mkdir -p "$dst/$(dirname "$p")"
  if [ -e "$dst/$p" ] && [ ! -L "$dst/$p" ]; then
    mv "$dst/$p" "$dst/$p.bak"
    echo "backed up $dst/$p -> $p.bak"
  fi
  ln -sfn "$src/$p" "$dst/$p"
  echo "linked $p"
done
