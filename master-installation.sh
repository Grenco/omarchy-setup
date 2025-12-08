#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

"$SCRIPT_DIR/install-tmux.sh"
"$SCRIPT_DIR/install-stow.sh"
"$SCRIPT_DIR/install-yazi.sh"
"$SCRIPT_DIR/install-dotfiles.sh"
"$SCRIPT_DIR/install-kanata.sh"

"$SCRIPT_DIR/set-shell.sh"
