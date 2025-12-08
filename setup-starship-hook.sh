#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -e ~/.config/omarchy/current/theme/neovim.lua ]; then
  # Set up starship theme hook
  if [ -f "$SCRIPT_DIR/hooks/omarchy-starship-hook.sh" ]; then
    mkdir -p ~/.config/omarchy/hooks
    ln -sf "$SCRIPT_DIR/hooks/omarchy-starship-hook.sh" ~/.config/omarchy/hooks/theme-set
    chmod +x ~/.config/omarchy/hooks/theme-set
    echo "  → Starship theme hook installed"

    # Generate initial starship config with current theme
    "$SCRIPT_DIR/hooks/omarchy-starship-hook.sh"
  fi
fi
