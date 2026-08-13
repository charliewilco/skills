#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
BACKUP_DIR="$CODEX_HOME/backups/skills-setup-$(date +%Y%m%d-%H%M%S)"

usage() {
  cat <<'USAGE'
Usage: ./setup.sh [--dry-run] [--force] [--replace-agents] [--no-agents]

Symlinks this repo's Codex content into $CODEX_HOME, defaulting to ~/.codex.

Options:
  --dry-run    Print actions without changing files.
  --force      Replace conflicting non-symlink paths after backing them up.
  --replace-agents
               Install Shared-AGENTS.md as ~/.codex/AGENTS.md instead of ~/.codex/Shared-AGENTS.md.
  --no-agents  Do not install Shared-AGENTS.md.
  -h, --help   Show this help.
USAGE
}

DRY_RUN=0
FORCE=0
INSTALL_AGENTS=1
REPLACE_AGENTS=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      ;;
    --force)
      FORCE=1
      ;;
    --replace-agents)
      REPLACE_AGENTS=1
      ;;
    --no-agents)
      INSTALL_AGENTS=0
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

run() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    printf 'dry-run:'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

ensure_dir() {
  run mkdir -p "$1"
}

backup_path() {
  local target="$1"
  ensure_dir "$BACKUP_DIR"
  run mv "$target" "$BACKUP_DIR/$(basename "$target")"
}

link_path() {
  local source="$1"
  local target="$2"

  if [[ ! -e "$source" ]]; then
    echo "Missing source: $source" >&2
    exit 1
  fi

  if [[ -L "$target" ]]; then
    local existing
    existing="$(readlink "$target")"
    if [[ "$existing" == "$source" ]]; then
      echo "Already linked: $target -> $source"
      return
    fi

    if [[ "$FORCE" -eq 0 ]]; then
      echo "Refusing to replace symlink: $target -> $existing" >&2
      echo "Rerun with --force to back it up and replace it." >&2
      exit 1
    fi

    backup_path "$target"
  elif [[ -e "$target" ]]; then
    if [[ "$FORCE" -eq 0 ]]; then
      echo "Refusing to replace existing path: $target" >&2
      echo "Rerun with --force to back it up and replace it." >&2
      exit 1
    fi

    backup_path "$target"
  fi

  ensure_dir "$(dirname "$target")"
  run ln -s "$source" "$target"
  echo "Linked: $target -> $source"
}

install_skill_links() {
  local skills_dir="$REPO_DIR/skills"
  local target_dir="$CODEX_HOME/skills"

  ensure_dir "$target_dir"

  find "$skills_dir" -mindepth 1 -maxdepth 1 -type d | sort | while read -r skill_dir; do
    if [[ -f "$skill_dir/SKILL.md" ]]; then
      link_path "$skill_dir" "$target_dir/$(basename "$skill_dir")"
    fi
  done
}

install_agents_link() {
  if [[ "$INSTALL_AGENTS" -eq 0 ]]; then
    echo "Skipping AGENTS install."
    return
  fi

  if [[ "$REPLACE_AGENTS" -eq 1 ]]; then
    link_path "$REPO_DIR/Shared-AGENTS.md" "$CODEX_HOME/AGENTS.md"
  else
    link_path "$REPO_DIR/Shared-AGENTS.md" "$CODEX_HOME/Shared-AGENTS.md"
  fi
}

install_directory_links() {
  local source_root="$1"
  local target_root="$2"
  local marker="$3"

  [[ -d "$source_root" ]] || return
  ensure_dir "$target_root"

  find "$source_root" -mindepth 1 -maxdepth 1 -type d | sort | while read -r item_dir; do
    if [[ -e "$item_dir/$marker" ]]; then
      link_path "$item_dir" "$target_root/$(basename "$item_dir")"
    fi
  done
}

echo "Repo: $REPO_DIR"
echo "Codex home: $CODEX_HOME"

install_skill_links
install_directory_links "$REPO_DIR/automations" "$CODEX_HOME/automations" "automation.toml"
install_directory_links "$REPO_DIR/plugins" "$CODEX_HOME/plugins" ".codex-plugin/plugin.json"
install_agents_link

if [[ "$DRY_RUN" -eq 0 && -d "$BACKUP_DIR" ]]; then
  echo "Backups written to: $BACKUP_DIR"
fi

echo "Setup complete."
