#!/bin/bash

set -e

# Install Bibata Modern Classic cursor theme
yay -S --needed --noconfirm bibata-cursor-theme

# Set cursor theme via gsettings for GTK apps
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'
gsettings set org.gnome.desktop.interface cursor-size 24

echo "Bibata Modern Classic cursor theme installed!"
echo "Note: You may need to log out and back in for all apps to use the new cursor."
