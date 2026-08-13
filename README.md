# Charlie's Codex Operating Repo

This repository is the shared layer for Charlie's Codex installations.

## Structure

- `skills/`: reusable Codex skills and skill candidates.
- `automations/`: proposed recurring Codex automations, monitors, and maintenance loops.
- `plugins/`: installed plugin inventory and plugin policy notes.
- `Shared-AGENTS.md`: portable expectations for how Codex should operate across installations.
- `setup.sh`: symlink installer for repo-owned Codex content.
- `NEXT.md`: prioritized backlog for expanding this repo.

## Current Fit

The existing skill set matches recurring work well:

- `skills/dirty-branch` and `skills/git-maid`: dirty branch triage, commit splitting, and WIP recovery.
- `skills/ios-preflight`: Apple project viability, simulator readiness, and Xcode churn diagnosis.
- `skills/issue-batch-planner`: milestone/backlog planning before implementation.
- `skills/migration-playbook`: staged migrations for APIs, runtimes, edge functions, and route retirement.
- `skills/openapi-parity`: contract drift checks for OpenAPI and generated clients.
- `skills/quality-gates-audit`: local and CI gate alignment.

The main gap is product-specific operational muscle. The strongest next skills to promote are Burton PR validation/merge, Burton fix PRs into `next`, iOS named-device validation, physical-device install/run, Reviewer provider live-proof workflows, and Xcode churn classification.

## Attribution

The `tdd`, `wait-what`, `wayfinder`, `research`, `grill-me`, and `handoff` skills are Charlie-specific adaptations inspired by Matt Pocock's MIT-licensed `mattpocock/skills` workflows.

## Installation Notes

This repo intentionally avoids committing machine secrets, live Codex state, SQLite databases, or private session logs.

Use `Shared-AGENTS.md` as the source text for the shared expectations layer, then keep local machine-specific overrides in `~/.codex/AGENTS.md` under a clearly marked local section.

Run the setup wizard:

```sh
sh ./setup.sh
```

The wizard asks which app to configure, whether to preview first, whether to replace the active agent instruction file, and whether conflicting paths should be backed up and replaced.

Preview Codex setup:

```sh
sh ./setup.sh --target codex --dry-run
```

Install all supported agent links:

```sh
sh ./setup.sh --target all
```

By default, `Shared-AGENTS.md` is linked as a shared reference file, not as the active instruction file. Use `sh ./setup.sh --target codex --replace-agents --force` only when this repo should own the active global agent file.

If a target already exists, the script stops instead of replacing it. Rerun with `--force` to move the existing target into that app home's `backups/` directory and install the symlink.
