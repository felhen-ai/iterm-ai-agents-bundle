#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<'USAGE'
Usage: ./install.sh [--codex] [--claude] [--agents] [--all]

Installs the bundled skills by copying skills/iterm-* into the selected local
skill directories.

Targets:
  --codex    ${CODEX_HOME:-$HOME/.codex}/skills
  --claude   $HOME/.claude/skills
  --agents   $HOME/.agents/skills
  --all      all of the above
USAGE
}

targets=()
if [[ $# -eq 0 ]]; then
  usage
  exit 2
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --codex)
      targets+=("${CODEX_HOME:-$HOME/.codex}/skills")
      ;;
    --claude)
      targets+=("$HOME/.claude/skills")
      ;;
    --agents)
      targets+=("$HOME/.agents/skills")
      ;;
    --all)
      targets+=("${CODEX_HOME:-$HOME/.codex}/skills" "$HOME/.claude/skills" "$HOME/.agents/skills")
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

skills=(iterm-control iterm-workspace iterm-diagnostics)

for target in "${targets[@]}"; do
  mkdir -p "$target"
  for skill in "${skills[@]}"; do
    rm -rf "$target/$skill"
    cp -R "$repo_root/skills/$skill" "$target/$skill"
    echo "installed $skill -> $target/$skill"
  done
done
