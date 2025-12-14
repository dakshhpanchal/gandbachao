#!/bin/bash
set -e

ROOT=$(dirname "$(realpath "$0")")/..

echo "=== Ubuntu Restore Started ==="

sudo apt update

if [ -f "$ROOT/packages/apt.txt" ]; then
  echo "Installing APT packages..."
  xargs -a "$ROOT/packages/apt.txt" sudo apt install -y || true
fi

if [ -f "$ROOT/packages/snap.txt" ]; then
  echo "Installing Snap packages..."
  while read -r pkg; do
    sudo snap install "$pkg" || true
  done < "$ROOT/packages/snap.txt"
fi

echo "Restoring dotfiles..."
rsync -a "$ROOT/dotfiles/" ~/

echo "Restoring GNOME settings..."
if [ -f "$ROOT/gnome/gnome.ini" ]; then
  dconf load /org/gnome/ < "$ROOT/gnome/gnome.ini"
fi

sudo apt install -y gnome-shell-extensions || true

if [ -f "$ROOT/gnome/extensions.txt" ]; then
  while read -r ext; do
    gnome-extensions enable "$ext" || true
  done < "$ROOT/gnome/extensions.txt"
fi

echo "=== Restore Completed ==="
echo "Log out and log back in to apply GNOME settings."
