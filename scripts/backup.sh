#!/bin/bash
set -e

ROOT=$(dirname "$(realpath "$0")")/..

echo "=== Ubuntu Backup Started ==="

echo "Backing up APT packages..."
mkdir -p "$ROOT/packages"
dpkg --get-selections | awk '{print $1}' > "$ROOT/packages/apt.txt"

echo "Backing up Snap packages..."
snap list | awk 'NR>1 {print $1}' > "$ROOT/packages/snap.txt"

echo "Backing up dotfiles..."
mkdir -p "$ROOT/dotfiles"
rsync -a --delete \
  ~/.zshrc \
  ~/.bashrc \
  ~/.gitconfig \
  ~/.config/nvim \
  "$ROOT/dotfiles/" 2>/dev/null || true

echo "Backing up GNOME settings..."
mkdir -p "$ROOT/gnome"

dconf dump /org/gnome/ > "$ROOT/gnome/gnome.ini"

if command -v gnome-extensions >/dev/null 2>&1; then
  gnome-extensions list > "$ROOT/gnome/extensions.txt"
fi

cd "$ROOT"
git add .
git commit -m "auto backup $(date '+%Y-%m-%d %H:%M')" || true
git push || true

echo "=== Backup Completed ==="
