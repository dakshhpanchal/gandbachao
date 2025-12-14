#!/bin/bash
set -e

ROOT=$(dirname "$(realpath "$0")")/..

echo "Backing up APT packages..."
dpkg --get-selections | awk '{print $1}' > "$ROOT/packages/apt.txt"

echo "Backing up Snap packages..."
snap list | awk 'NR>1 {print $1}' > "$ROOT/packages/snap.txt"

echo "Backing up dotfiles..."
rsync -a --delete \
  ~/.zshrc ~/.bashrc ~/.gitconfig ~/.config/nvim \
  "$ROOT/dotfiles/"

echo "Backup complete"

cd "$ROOT"
git add .
git commit -m "auto backup $(date '+%Y-%m-%d %H:%M')" || true
git push