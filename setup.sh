#!/usr/bin/env bash
# setup.sh — Bootstrap Claude Code academic workflow on a new machine
#
# Usage:
#   bash setup.sh
#
# What it does:
#   1. Creates symlinks in ~/.claude/ for skills, agents, and rules
#   2. Appends the workflow section to ~/CLAUDE.md (idempotent)
#
# Run this once after cloning on any machine.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_GLOBAL="$HOME/.claude"
MARKER="## Claude Code Workflow (auto-added by setup.sh)"

echo "==> Setting up Claude Code workflow from: $REPO_DIR"

# ── 1. Symlinks in ~/.claude/ ────────────────────────────────────────────────

for dir in skills agents rules; do
  src="$REPO_DIR/.claude/$dir"
  dst="$CLAUDE_GLOBAL/$dir"

  if [ -L "$dst" ]; then
    echo "  [skip] $dst already a symlink"
  elif [ -e "$dst" ]; then
    echo "  [warn] $dst exists and is not a symlink — skipping (resolve manually)"
  else
    ln -s "$src" "$dst"
    echo "  [ok]   $dst → $src"
  fi
done

# ── 2. Append workflow section to ~/CLAUDE.md ────────────────────────────────

HOME_CLAUDE="$HOME/CLAUDE.md"
TEMPLATE="$REPO_DIR/templates/home-claude-md-workflow.md"

if [ ! -f "$TEMPLATE" ]; then
  echo "  [warn] Template not found: $TEMPLATE — skipping CLAUDE.md update"
else
  if grep -qF "$MARKER" "$HOME_CLAUDE" 2>/dev/null; then
    echo "  [skip] Workflow section already present in ~/CLAUDE.md"
  else
    echo "" >> "$HOME_CLAUDE"
    cat "$TEMPLATE" >> "$HOME_CLAUDE"
    echo "  [ok]   Appended workflow section to ~/CLAUDE.md"
  fi
fi

echo ""
echo "==> Done. Skills, agents, and rules are now available in all projects."
echo "    Hooks are project-local — copy .claude/hooks/ into each project as needed."
