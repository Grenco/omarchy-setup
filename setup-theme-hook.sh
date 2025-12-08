#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -e ~/.config/omarchy/current/theme/neovim.lua ]; then
  # Set up theme hook (starship + tmux)
  if [ -f "$SCRIPT_DIR/hooks/omarchy-theme-hook.sh" ]; then
    mkdir -p ~/.config/omarchy/hooks
    ln -sf "$SCRIPT_DIR/hooks/omarchy-theme-hook.sh" ~/.config/omarchy/hooks/theme-set
    chmod +x ~/.config/omarchy/hooks/theme-set
    echo "  → Theme hook installed (starship + tmux)"

    # Generate initial configs with current theme
    "$SCRIPT_DIR/hooks/omarchy-theme-hook.sh"
  fi
fi
