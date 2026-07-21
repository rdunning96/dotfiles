#!/usr/bin/env zsh
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# ── Dependencies ──────────────────────────────────────────────────────────────
if ! command -v stow &>/dev/null; then
  echo "Installing stow..."
  brew install stow
fi

# ── Stow packages ─────────────────────────────────────────────────────────────
PACKAGES=(zsh git vim tmux claude)
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

for pkg in $PACKAGES; do
  # Back up anything at the target path that would block stow (pre-existing
  # plain files/dirs from before this repo managed them) so re-running this
  # script on a machine with prior config doesn't just abort.
  conflicts=$(stow -n --target="$HOME" --dir="$DOTFILES" "$pkg" 2>&1 | \
    sed -n -E \
      -e 's/.*over existing target (.*) since.*/\1/p' \
      -e 's/.*existing target is not owned by stow: (.*)/\1/p')

  if [[ -n "$conflicts" ]]; then
    echo "Backing up conflicting files for $pkg..."
    while IFS= read -r rel; do
      [[ -z "$rel" ]] && continue
      src="$HOME/$rel"
      dest="$BACKUP_DIR/$pkg/$rel"
      mkdir -p "$(dirname "$dest")"
      mv "$src" "$dest"
      echo "  $src -> $dest"
    done <<< "$conflicts"
  fi

  echo "Stowing $pkg..."
  stow --target="$HOME" --dir="$DOTFILES" "$pkg"
done

if [[ -d "$BACKUP_DIR" ]]; then
  echo ""
  echo "Pre-existing files backed up under: $BACKUP_DIR"
fi

# ── VSCode ────────────────────────────────────────────────────────────────────
if command -v code &>/dev/null && [[ -f "$DOTFILES/vscode/extensions.list" ]]; then
  echo "Installing VSCode extensions..."
  while IFS= read -r ext; do
    code --install-extension "$ext" --force
  done < "$DOTFILES/vscode/extensions.list"
fi

# ── Env reminders ─────────────────────────────────────────────────────────────
echo ""
echo "Done. Don't forget to fill in:"
echo "  ~/.gitconfig → set your email (see .env.examples/gitconfig.env.example)"
echo ""
echo "  git config --global user.email 'your@email.com'"
