#!/bin/bash

set -e

HYPRLAND_CONFIG="$HOME/.config/hypr/hyprland.lua"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OVERRIDES_SOURCE="$SCRIPT_DIR/config/hyprland-overrides.lua"
OVERRIDES_CONFIG="$HOME/.config/hypr/overrides.lua"
SOURCE_LINE='dofile(os.getenv("HOME") .. "/.config/hypr/overrides.lua")'
OLD_SOURCE_LINE="dofile(\"$OVERRIDES_SOURCE\")"

# Check if hyprland config exists
if [ ! -f "$HYPRLAND_CONFIG" ]; then
  echo "Hyprland config not found at $HYPRLAND_CONFIG"
  echo "Please install hyprland first"
  exit 1
fi

# Check if overrides config exists
if [ ! -f "$OVERRIDES_SOURCE" ]; then
  echo "Overrides config not found at $OVERRIDES_SOURCE"
  exit 1
fi

if [ -e "$OVERRIDES_CONFIG" ] && [ ! -L "$OVERRIDES_CONFIG" ]; then
  echo "Cannot create override symlink: $OVERRIDES_CONFIG already exists and is not a symlink"
  exit 1
fi

ln -sfn "$OVERRIDES_SOURCE" "$OVERRIDES_CONFIG"
echo "Override symlink points to $OVERRIDES_SOURCE"

# Replace the repository-specific loader written by older versions of this script.
if grep -Fxq "$OLD_SOURCE_LINE" "$HYPRLAND_CONFIG"; then
  sed -i "\|^$OLD_SOURCE_LINE$|c\\$SOURCE_LINE" "$HYPRLAND_CONFIG"
fi

# Check if the override is already loaded by hyprland.lua
if grep -Fxq "$SOURCE_LINE" "$HYPRLAND_CONFIG"; then
  echo "Override loader already exists in $HYPRLAND_CONFIG"
else
  echo "Adding override loader to $HYPRLAND_CONFIG"
  printf '\n%s\n' "$SOURCE_LINE" >>"$HYPRLAND_CONFIG"
  echo "Override loader added successfully"
fi

echo "Hyprland overrides setup complete!"
