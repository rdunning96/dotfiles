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

for pkg in $PACKAGES; do
  echo "Stowing $pkg..."
  stow --target="$HOME" --dir="$DOTFILES" "$pkg"
done

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
