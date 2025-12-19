#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

"$SCRIPT_DIR/install-tmux.sh"
"$SCRIPT_DIR/install-stow.sh"
"$SCRIPT_DIR/install-yazi.sh"
"$SCRIPT_DIR/install-hyprland-overrides.sh"
"$SCRIPT_DIR/install-dotfiles.sh"
"$SCRIPT_DIR/install-kanata.sh"

"$SCRIPT_DIR/setup-theme-hook.sh"

"$SCRIPT_DIR/set-shell.sh"
