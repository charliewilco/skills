#!/bin/sh
set -eu

REPO_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TARGET=""
DRY_RUN=0
FORCE=0
INSTALL_AGENTS=1
REPLACE_AGENTS=0
DRY_RUN_SET=0
FORCE_SET=0
REPLACE_AGENTS_SET=0

CODEX_HOME=${CODEX_HOME:-"$HOME/.codex"}
CLAUDE_HOME=${CLAUDE_HOME:-"$HOME/.claude"}
ANTIGRAVITY_HOME=${ANTIGRAVITY_HOME:-"$HOME/.antigravity"}

usage() {
  cat <<'USAGE'
Usage: sh ./setup.sh [--target codex|claude|antigravity|all] [options]

Runs a small setup wizard for symlinking this repo's shared agent content into
Codex, Claude, or Antigravity.

Options:
  --target NAME       Install for codex, claude, antigravity, or all.
  --dry-run           Print actions without changing files.
  --force             Replace conflicting paths after backing them up.
  --replace-agents    Link Shared-AGENTS.md as the active agent instruction file.
  --no-agents         Do not link Shared-AGENTS.md.
  -h, --help          Show this help.

Environment overrides:
  CODEX_HOME          Default: ~/.codex
  CLAUDE_HOME         Default: ~/.claude
  ANTIGRAVITY_HOME    Default: ~/.antigravity
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target)
      [ "$#" -ge 2 ] || {
        echo "--target requires a value" >&2
        exit 2
      }
      TARGET=$2
      shift
      ;;
    --target=*)
      TARGET=${1#--target=}
      ;;
    --dry-run)
      DRY_RUN=1
      DRY_RUN_SET=1
      ;;
    --force)
      FORCE=1
      FORCE_SET=1
      ;;
    --replace-agents)
      REPLACE_AGENTS=1
      REPLACE_AGENTS_SET=1
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

prompt_target() {
  if [ -n "$TARGET" ]; then
    return
  fi

  if [ ! -t 0 ]; then
    TARGET=codex
    return
  fi

  cat <<EOF
Choose what to set up:
  1) Codex        ($CODEX_HOME)
  2) Claude       ($CLAUDE_HOME)
  3) Antigravity  ($ANTIGRAVITY_HOME)
  4) All
EOF
  printf "Selection [1]: "
  read answer
  case "${answer:-1}" in
    1|codex|Codex)
      TARGET=codex
      ;;
    2|claude|Claude)
      TARGET=claude
      ;;
    3|antigravity|Antigravity)
      TARGET=antigravity
      ;;
    4|all|All)
      TARGET=all
      ;;
    *)
      echo "Unknown selection: $answer" >&2
      exit 2
      ;;
  esac
}

prompt_options() {
  if [ ! -t 0 ]; then
    return
  fi

  if [ "$DRY_RUN_SET" -eq 0 ]; then
    printf "Preview actions first? [Y/n]: "
    read answer
    case "${answer:-y}" in
      y|Y|yes|YES|Yes)
        DRY_RUN=1
        ;;
      n|N|no|NO|No)
        DRY_RUN=0
        ;;
      *)
        echo "Unknown answer: $answer" >&2
        exit 2
        ;;
    esac
  fi

  if [ "$REPLACE_AGENTS_SET" -eq 0 ]; then
    printf "Replace active agent instruction files? [y/N]: "
    read answer
    case "${answer:-n}" in
      y|Y|yes|YES|Yes)
        REPLACE_AGENTS=1
        ;;
      n|N|no|NO|No)
        REPLACE_AGENTS=0
        ;;
      *)
        echo "Unknown answer: $answer" >&2
        exit 2
        ;;
    esac
  fi

  if [ "$FORCE_SET" -eq 0 ]; then
    printf "Back up and replace conflicting paths if needed? [y/N]: "
    read answer
    case "${answer:-n}" in
      y|Y|yes|YES|Yes)
        FORCE=1
        ;;
      n|N|no|NO|No)
        FORCE=0
        ;;
      *)
        echo "Unknown answer: $answer" >&2
        exit 2
        ;;
    esac
  fi
}

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf "dry-run:"
    for arg in "$@"; do
      printf " %s" "$arg"
    done
    printf "\n"
  else
    "$@"
  fi
}

ensure_dir() {
  run mkdir -p "$1"
}

backup_path() {
  target_path=$1
  backup_root=$2
  ensure_dir "$backup_root"
  run mv "$target_path" "$backup_root/$(basename -- "$target_path")"
}

link_path() {
  source_path=$1
  target_path=$2
  backup_root=$3

  if [ ! -e "$source_path" ]; then
    echo "Missing source: $source_path" >&2
    exit 1
  fi

  if [ -L "$target_path" ]; then
    existing=$(readlink "$target_path")
    if [ "$existing" = "$source_path" ]; then
      echo "Already linked: $target_path -> $source_path"
      return
    fi

    if [ "$FORCE" -eq 0 ]; then
      echo "Refusing to replace symlink: $target_path -> $existing" >&2
      echo "Rerun with --force to back it up and replace it." >&2
      exit 1
    fi

    backup_path "$target_path" "$backup_root"
  elif [ -e "$target_path" ]; then
    if [ "$FORCE" -eq 0 ]; then
      echo "Refusing to replace existing path: $target_path" >&2
      echo "Rerun with --force to back it up and replace it." >&2
      exit 1
    fi

    backup_path "$target_path" "$backup_root"
  fi

  ensure_dir "$(dirname -- "$target_path")"
  run ln -s "$source_path" "$target_path"
  echo "Linked: $target_path -> $source_path"
}

install_skill_links() {
  source_root=$1
  target_root=$2
  backup_root=$3

  ensure_dir "$target_root"

  find "$source_root" -mindepth 1 -maxdepth 1 -type d | sort | while IFS= read -r skill_dir; do
    if [ -f "$skill_dir/SKILL.md" ]; then
      link_path "$skill_dir" "$target_root/$(basename -- "$skill_dir")" "$backup_root"
    fi
  done
}

install_directory_links() {
  source_root=$1
  target_root=$2
  marker=$3
  backup_root=$4

  [ -d "$source_root" ] || return
  ensure_dir "$target_root"

  find "$source_root" -mindepth 1 -maxdepth 1 -type d | sort | while IFS= read -r item_dir; do
    if [ -e "$item_dir/$marker" ]; then
      link_path "$item_dir" "$target_root/$(basename -- "$item_dir")" "$backup_root"
    fi
  done
}

install_shared_agents() {
  app_home=$1
  default_target=$2
  active_target=$3
  backup_root=$4

  if [ "$INSTALL_AGENTS" -eq 0 ]; then
    echo "Skipping shared agent instructions."
    return
  fi

  if [ "$REPLACE_AGENTS" -eq 1 ]; then
    link_path "$REPO_DIR/Shared-AGENTS.md" "$active_target" "$backup_root"
  else
    link_path "$REPO_DIR/Shared-AGENTS.md" "$default_target" "$backup_root"
  fi
}

install_codex() {
  backup_root="$CODEX_HOME/backups/skills-setup-$(date +%Y%m%d-%H%M%S)"

  echo ""
  echo "Setting up Codex at $CODEX_HOME"
  install_skill_links "$REPO_DIR/skills" "$CODEX_HOME/skills" "$backup_root"
  install_directory_links "$REPO_DIR/automations" "$CODEX_HOME/automations" "automation.toml" "$backup_root"
  install_directory_links "$REPO_DIR/plugins" "$CODEX_HOME/plugins" ".codex-plugin/plugin.json" "$backup_root"
  install_shared_agents "$CODEX_HOME" "$CODEX_HOME/Shared-AGENTS.md" "$CODEX_HOME/AGENTS.md" "$backup_root"
}

install_claude() {
  backup_root="$CLAUDE_HOME/backups/skills-setup-$(date +%Y%m%d-%H%M%S)"

  echo ""
  echo "Setting up Claude at $CLAUDE_HOME"
  install_skill_links "$REPO_DIR/skills" "$CLAUDE_HOME/skills" "$backup_root"
  install_shared_agents "$CLAUDE_HOME" "$CLAUDE_HOME/Shared-AGENTS.md" "$CLAUDE_HOME/CLAUDE.md" "$backup_root"
}

install_antigravity() {
  backup_root="$ANTIGRAVITY_HOME/backups/skills-setup-$(date +%Y%m%d-%H%M%S)"

  echo ""
  echo "Setting up Antigravity at $ANTIGRAVITY_HOME"
  install_skill_links "$REPO_DIR/skills" "$ANTIGRAVITY_HOME/skills" "$backup_root"
  install_shared_agents "$ANTIGRAVITY_HOME" "$ANTIGRAVITY_HOME/Shared-AGENTS.md" "$ANTIGRAVITY_HOME/AGENTS.md" "$backup_root"
}

prompt_target
prompt_options

case "$TARGET" in
  codex)
    install_codex
    ;;
  claude)
    install_claude
    ;;
  antigravity)
    install_antigravity
    ;;
  all)
    install_codex
    install_claude
    install_antigravity
    ;;
  *)
    echo "Unknown target: $TARGET" >&2
    usage >&2
    exit 2
    ;;
esac

echo ""
echo "Setup complete."
