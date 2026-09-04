#!/bin/sh

set -e

sudo pacman -S --noconfirm --needed omarchy-zsh

# Run Omarchy setup script for zsh
omarchy-setup-zsh

# Change the default shell to zsh
ZSH_PATH="$(command -v zsh)"
sudo chsh -s "$ZSH_PATH" "$USER"
