# dotfiles

## claude/

Claude Code config (`~/.claude`). Run `claude/install.sh` to symlink it into place.

Not tracked: credentials, history, projects, plugins (reinstalled from `enabledPlugins` in `settings.json`), skills symlinked from `~/.agents/skills`, `skills/synced`, and the herdr-managed hook.

If Claude Code rewrites `settings.json` and replaces the symlink with a plain file, copy it back into `claude/` and rerun `install.sh`.

## omp/

omp config (`~/.omp/agent`). Run `omp/install.sh` to symlink it into place.

Tracked: `config.yml`, `RULES.md` (sticky global rules, also seen by subagents), the cavecrew agents and `that-review` skill (omp-adapted copies of the Claude ones: `task`/`read`/`skill://` instead of `Agent`/`Read`/Skill tool), and `skills/review-code` (symlink to `claude/skills/review-code`, shared as-is).

Not tracked: sessions, `*.db`, caches, natives, plugins (reinstall ponytail with the omp marketplace from `DietrichGebert/ponytail`).

If omp rewrites `config.yml` and replaces the symlink with a plain file, copy it back into `omp/` and rerun `install.sh`.
