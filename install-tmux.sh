#!/bin/bash

set -e

# Install tmux
sudo pacman -S --noconfirm --needed tmux

# Check if tmux is installed
if ! command -v tmux &>/dev/null; then
  echo "tmux installation failed."
  exit 1
fi

TPM_DIR="$HOME/.tmux/plugins/tpm"
TMUX_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/tmux"
TMUX_CONFIG="$TMUX_CONFIG_DIR/tmux.conf"
SOURCE_LINE='source-file -q ~/.tmux.conf'

# Check if TPM is already installed
if [ -d "$TPM_DIR" ]; then
  echo "TPM is already installed in $TPM_DIR"
else
  echo "Installing Tmux Plugin Manager (TPM)..."
  git clone https://github.com/tmux-plugins/tpm $TPM_DIR
fi

mkdir -p "$TMUX_CONFIG_DIR"
touch "$TMUX_CONFIG"
if ! grep -Fxq "$SOURCE_LINE" "$TMUX_CONFIG"; then
  printf '\n%s\n' "$SOURCE_LINE" >>"$TMUX_CONFIG"
fi

echo "Installing tmux plugins..."
"$TPM_DIR/bin/install_plugins"

echo "TPM and tmux plugins installed successfully!"
