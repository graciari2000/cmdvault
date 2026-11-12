#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${HOME}/.local/bin"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/cmdvault"
mkdir -p "$BIN_DIR" "$DATA_DIR"
cp "$ROOT/cmdvault.py" "$BIN_DIR/cmdvault"
chmod 755 "$BIN_DIR/cmdvault"

HOOK="$ROOT/cmdvault.sh"
for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
  [ -e "$rc" ] || touch "$rc"
  if ! grep -Fq '# CmdVault shell integration' "$rc"; then
    printf '\n# CmdVault shell integration\nsource "%s"\n' "$HOOK" >> "$rc"
  fi
done

echo "CmdVault installed. Restart your terminal, type a prefix, then press Ctrl+Space."
case ":$PATH:" in *":$BIN_DIR:"*) ;; *) echo "Add $BIN_DIR to PATH if cmdvault is not found." ;; esac
