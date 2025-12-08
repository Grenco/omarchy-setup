#!/bin/sh

# Get the path to zsh
ZSH_PATH=$(which zsh)

# Check if zsh is already the default shell
if [ "$SHELL" = "$ZSH_PATH" ]; then
    echo "Zsh is already your default shell."
    exit 0
fi

# Run Omarchy setup script for zsh
omarchy-setup-zsh

# Change the default shell to zsh
chsh -s "$ZSH_PATH"
