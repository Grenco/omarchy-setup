#!/bin/sh

sudo pacman -S --noconfirm --needed omarchy-setup-zsh

# Run Omarchy setup script for zsh
omarchy-setup-zsh

# Change the default shell to zsh
sudo chsh -s "$ZSH_PATH" $USER
