#!/bin/zsh
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$DOTFILES_DIR/include/shared_vars.sh"

skip_pattern=$(printf "|%s" "${_DOTFILES_INFRA[@]}")
skip_pattern="${skip_pattern:1}"

echo "[+] Removing stowed symlinks..."
for pkg_dir in "$DOTFILES_DIR"/*/; do
    pkg=$(basename "$pkg_dir")
    if echo "$pkg" | grep -qE "^($skip_pattern)$"; then
        continue
    fi
    echo "    unstow: $pkg"
    stow --dir="$DOTFILES_DIR" --target="$HOME_DIR" --delete "$pkg" 2>/dev/null || true
done
echo "[+] All symlinks removed"
