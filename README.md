# dotfiles

## claude/

Claude Code config (`~/.claude`). Run `claude/install.sh` to symlink it into place.

Not tracked: credentials, history, projects, plugins (reinstalled from `enabledPlugins` in `settings.json`), skills symlinked from `~/.agents/skills`, `skills/synced`, and the herdr-managed hook.

If Claude Code rewrites `settings.json` and replaces the symlink with a plain file, copy it back into `claude/` and rerun `install.sh`.
