# Agent Setup

Shared skills, instructions, plugin notes, and automation ideas for Charlie's agent tools.

This repo is meant to be checked out once and linked into each agent installation. The files stay versioned here; local agent homes get symlinks.

## What's In Here

- `skills/` - reusable skills for coding, research, planning, handoff, repo hygiene, and validation workflows.
- `automations/` - report-only automation ideas and future Codex automation definitions.
- `plugins/` - plugin inventory and notes about which connectors are worth installing.
- `Shared-AGENTS.md` - portable agent expectations shared across installations.
- `setup.sh` - installer/wizard that links this repo into supported agent homes.
- `NEXT.md` - backlog for the next skills, automations, and plugin work.

## Setup

Run the wizard:

```sh
sh ./setup.sh
```

The wizard asks:

- which target to configure: Codex, Claude, Antigravity, or all
- whether to preview changes first
- whether to replace the active agent instruction file
- whether to back up and replace conflicting paths

Non-interactive examples:

```sh
sh ./setup.sh --target codex --dry-run
sh ./setup.sh --target claude
sh ./setup.sh --target antigravity
sh ./setup.sh --target all
```

By default, setup links `Shared-AGENTS.md` as a reference file instead of replacing the active instruction file. To make this repo own the active Codex instructions:

```sh
sh ./setup.sh --target codex --replace-agents --force
```

Conflicting files are never overwritten silently. With `--force`, the script first moves the old path into that app home's `backups/` directory.

## Target Homes

Defaults can be overridden with environment variables:

```sh
CODEX_HOME=~/.codex
CLAUDE_HOME=~/.claude
ANTIGRAVITY_HOME=~/.antigravity
```

Example:

```sh
ANTIGRAVITY_HOME="$HOME/Library/Application Support/Antigravity" sh ./setup.sh --target antigravity
```

## What Belongs Here

Add content that should follow Charlie across agent installations:

- repeatable skills
- shared behavior expectations
- report-only automation definitions
- plugin setup notes
- tiny scripts that make installation or validation safer

Do not commit local agent state, secrets, task transcripts, SQLite databases, generated logs, provider tokens, or machine-specific cache data.

## Workflow

Keep changes small:

- one PR for installer behavior
- one PR for a related set of skills
- one PR for automation definitions
- one PR for shared instruction changes

For skill changes, include a quick validation note in the PR: frontmatter checked, setup dry-run saw the skill, and any scripts passed syntax checks.

## Attribution

Some workflow skills are Charlie-specific adaptations inspired by Matt Pocock's MIT-licensed [`mattpocock/skills`](https://github.com/mattpocock/skills) repository.
