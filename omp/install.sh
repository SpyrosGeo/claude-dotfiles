#!/usr/bin/env bash
# Symlink tracked omp config into ~/.omp/agent. Re-runnable; an existing real file is moved to <name>.bak.
set -euo pipefail
src="$(cd "$(dirname "$0")" && pwd)"
dst="$HOME/.omp/agent"
paths=(
  config.yml
  agents/cavecrew-builder.md
  agents/cavecrew-investigator.md
  agents/cavecrew-reviewer.md
  skills/review-code
  skills/that-review
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
