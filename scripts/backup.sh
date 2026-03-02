#!/usr/bin/env bash
set -e

ROOT=$(dirname "$(realpath "$0")")/..

log() {
  echo "[UBUNTU-BACKUP] $1"
}

log "Backup process initiated."
log "Root directory: $ROOT"

log "Exporting APT package list..."
mkdir -p "$ROOT/packages"
dpkg --get-selections | awk '{print $1}' > "$ROOT/packages/apt.txt"
log "APT package list saved."

log "Exporting Snap package list..."
snap list | awk 'NR>1 {print $1}' > "$ROOT/packages/snap.txt"
log "Snap package list saved."

log "Synchronizing selected dotfiles..."
mkdir -p "$ROOT/dotfiles"
rsync -a --delete \
  ~/.zshrc \
  ~/.bashrc \
  ~/.gitconfig \
  ~/.config/nvim \
  "$ROOT/dotfiles/" 2>/dev/null || true
log "Dotfiles synchronization complete."

log "Exporting GNOME settings..."
mkdir -p "$ROOT/gnome"
dconf dump /org/gnome/ > "$ROOT/gnome/gnome.ini"
log "GNOME settings exported."

if command -v gnome-extensions >/dev/null 2>&1; then
  log "Recording installed GNOME extensions..."
  gnome-extensions list > "$ROOT/gnome/extensions.txt"
  log "Extension list saved."
fi

log "Committing changes to repository..."
cd "$ROOT"
git add .
git commit -m "Automated backup: $(date '+%Y-%m-%d %H:%M')" >/dev/null 2>&1 || log "No changes to commit."

log "Pushing to remote..."
git push >/dev/null 2>&1 || log "Git push failed or no remote configured."

log "Backup process completed successfully."