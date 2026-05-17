#!/usr/bin/env bash
# Deploy this tmux config to ~/.config/tmux and install TPM.
# Run from anywhere: ./install.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME/.config/tmux"
TPM_DIR="$HOME/.tmux/plugins/tpm"

# 1. Place config at $TARGET
if [ "$REPO_DIR" = "$TARGET" ]; then
  echo "✓ Config is already at $TARGET (no symlink needed)"
elif [ -L "$TARGET" ] && [ "$(readlink -f "$TARGET")" = "$REPO_DIR" ]; then
  echo "✓ $TARGET already symlinks to $REPO_DIR"
elif [ -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
  echo "ERROR: $TARGET exists and is not a symlink to this repo." >&2
  echo "       Move or delete it, then re-run." >&2
  exit 1
else
  mkdir -p "$(dirname "$TARGET")"
  ln -sfn "$REPO_DIR" "$TARGET"
  echo "✓ Symlinked $REPO_DIR -> $TARGET"
fi

# 2. Clone TPM
if [ ! -d "$TPM_DIR" ]; then
  mkdir -p "$(dirname "$TPM_DIR")"
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
  echo "✓ Cloned TPM to $TPM_DIR"
else
  echo "✓ TPM already present at $TPM_DIR"
fi

# 3. tmux version check (catppuccin v2 needs >= 3.2)
if ! command -v tmux >/dev/null; then
  echo "ERROR: tmux is not installed" >&2
  exit 1
fi
TMUX_VER=$(tmux -V | sed 's/tmux //; s/[a-z]//g')
echo "✓ tmux version: $TMUX_VER (catppuccin v2 needs >= 3.2)"

# 4. Optional dependency warnings (non-fatal)
warn() { printf '  \033[33m!\033[0m %s missing — features that need it will be inactive\n' "$1"; }
command -v fzf    >/dev/null || warn "fzf (sessionx, fzf-url)"
command -v zoxide >/dev/null || warn "zoxide (sessionx zoxide-mode)"

cat <<EOF

Next steps:
  1. Start tmux:        tmux
  2. Install plugins:   prefix + I       (prefix is Ctrl+A)
  3. Reload config:     prefix + R

To switch theme later, edit ~/.config/tmux/tmux.conf and swap which
'source-file ~/.config/tmux/themes/*.conf' line is commented.
EOF
