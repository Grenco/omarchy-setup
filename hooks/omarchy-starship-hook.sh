#!/bin/bash
# Omarchy theme-set hook: Updates starship palette with current theme colors
# Place this at ~/.config/omarchy/hooks/theme-set (make executable)
# Or run manually: ~/setup/omarchy-starship-hook.sh

set -e

OMARCHY_THEME_LINK="$HOME/.config/omarchy/current/theme"
STARSHIP_CONFIG="$HOME/.config/starship.toml"
STARSHIP_TEMPLATE="$HOME/dotfiles/starship/.config/starship.toml.template"

# Check if Omarchy is available
if [ ! -e "$OMARCHY_THEME_LINK" ]; then
  # No Omarchy - copy template with default Catppuccin Mocha
  if [ -f "$STARSHIP_TEMPLATE" ]; then
    cp "$STARSHIP_TEMPLATE" "$STARSHIP_CONFIG"
    echo "No Omarchy theme detected, using default Catppuccin Mocha"
  fi
  exit 0
fi

# Get current theme
THEME_PATH=$(readlink -f "$OMARCHY_THEME_LINK")
THEME_NAME=$(basename "$THEME_PATH")
PALETTE_NAME=$(echo "$THEME_NAME" | tr '-' '_')

# Parse colors from alacritty.toml
ALACRITTY_FILE="$THEME_PATH/alacritty.toml"

if [ ! -f "$ALACRITTY_FILE" ]; then
  echo "Could not find alacritty.toml for theme: $THEME_NAME"
  cp "$STARSHIP_TEMPLATE" "$STARSHIP_CONFIG" 2>/dev/null || true
  exit 1
fi

# Extract colors from alacritty.toml
parse_color() {
  local section=$1
  local key=$2
  grep -A 20 "^\[colors.$section\]" "$ALACRITTY_FILE" 2>/dev/null |
    grep "^$key" | head -1 |
    sed -E "s/^$key *= *[\"']?0?x?#?([0-9a-fA-F]{6})[\"']?.*/\1/" |
    awk '{print "#" tolower($0)}'
}

# Primary colors
BG=$(parse_color "primary" "background")
FG=$(parse_color "primary" "foreground")

# Normal colors
RED=$(parse_color "normal" "red")
GREEN=$(parse_color "normal" "green")
YELLOW=$(parse_color "normal" "yellow")
BLUE=$(parse_color "normal" "blue")
MAGENTA=$(parse_color "normal" "magenta")
CYAN=$(parse_color "normal" "cyan")
WHITE=$(parse_color "normal" "white")
BLACK=$(parse_color "normal" "black")

# Bright colors
BRIGHT_RED=$(parse_color "bright" "red")
BRIGHT_GREEN=$(parse_color "bright" "green")
BRIGHT_YELLOW=$(parse_color "bright" "yellow")
BRIGHT_BLUE=$(parse_color "bright" "blue")
BRIGHT_MAGENTA=$(parse_color "bright" "magenta")
BRIGHT_CYAN=$(parse_color "bright" "cyan")
BRIGHT_WHITE=$(parse_color "bright" "white")

# Fallback colors if parsing failed
: ${BG:="#1e1e2e"}
: ${FG:="#cdd6f4"}
: ${RED:="#f38ba8"}
: ${GREEN:="#a6e3a1"}
: ${YELLOW:="#f9e2af"}
: ${BLUE:="#89b4fa"}
: ${MAGENTA:="#b4befe"}
: ${CYAN:="#94e2d5"}
: ${WHITE:="#bac2de"}
: ${BLACK:="#45475a"}
: ${BRIGHT_WHITE:="${WHITE}"}

# Copy template
cp "$STARSHIP_TEMPLATE" "$STARSHIP_CONFIG"

# Build palette - map terminal colors to starship color names
cat >>"$STARSHIP_CONFIG" <<EOF

# $THEME_NAME theme palette (auto-generated)
[palettes.$PALETTE_NAME]
base = "$BG"
mantle = "$BLACK"
crust = "$BLACK"
surface0 = "$BLACK"
surface1 = "$BLACK"
surface2 = "$BLACK"
text = "$FG"
subtext1 = "$WHITE"
subtext0 = "$WHITE"
overlay0 = "$WHITE"
overlay1 = "$WHITE"
overlay2 = "$WHITE"
red = "$RED"
maroon = "$BRIGHT_RED"
green = "$GREEN"
yellow = "$YELLOW"
peach = "$YELLOW"
blue = "$BLUE"
sapphire = "$BRIGHT_BLUE"
sky = "$CYAN"
teal = "$CYAN"
cyan = "$BRIGHT_CYAN"
lavender = "$MAGENTA"
purple = "$MAGENTA"
pink = "$BRIGHT_MAGENTA"
flamingo = "$BRIGHT_MAGENTA"
rosewater = "$BRIGHT_WHITE"
orange = "$YELLOW"
EOF

# Update palette reference at the top of the file
sed -i "s/^palette = 'catppuccin_mocha'/palette = '$PALETTE_NAME'/" "$STARSHIP_CONFIG"

echo "✓ Starship config updated with $THEME_NAME theme"
