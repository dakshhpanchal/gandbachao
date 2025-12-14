#!/bin/bash
set -e

ROOT=$(dirname "$(realpath "$0")")/..

sudo apt update

echo "Installing APT packages..."
xargs -a "$ROOT/packages/apt.txt" sudo apt install -y

echo "Installing Snap packages..."
while read -r pkg; do
  sudo snap install "$pkg" || true
done < "$ROOT/packages/snap.txt"

echo "Restoring dotfiles..."
rsync -a "$ROOT/dotfiles/" ~/

echo "Restore complete"
