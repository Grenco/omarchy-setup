#!/bin/bash
# Omarchy theme-set hook: Updates starship + tmux with current theme colors
# Symlinked at ~/.config/omarchy/hooks/theme-set
# Or run manually: ~/setup/hooks/omarchy-theme-hook.sh

set -e

OMARCHY_THEME_LINK="$HOME/.config/omarchy/current/theme"
STARSHIP_CONFIG="$HOME/dotfiles/starship/.config/starship.toml"
TMUX_COLORS_FILE="$HOME/.tmux/colors.conf"

# Check if Omarchy is available
if [ ! -e "$OMARCHY_THEME_LINK" ]; then
  echo "No Omarchy theme detected"
  # Reset starship to catppuccin_mocha
  if [ -f "$STARSHIP_CONFIG" ]; then
    sed -i "s/^palette = .*/palette = 'catppuccin_mocha'/" "$STARSHIP_CONFIG"
  fi
  # Remove stale tmux colors
  rm -f "$TMUX_COLORS_FILE"
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

#
# UPDATE STARSHIP
#
if [ -f "$STARSHIP_CONFIG" ]; then
  # Build palette section
  PALETTE_CONTENT="# BEGIN OMARCHY PALETTE
[palettes.omarchy]
# Auto-generated from $THEME_NAME theme
base = \"$BG\"
mantle = \"$BLACK\"
crust = \"$BLACK\"
surface0 = \"$BLACK\"
surface1 = \"$BLACK\"
surface2 = \"$BLACK\"
text = \"$FG\"
subtext1 = \"$WHITE\"
subtext0 = \"$WHITE\"
overlay0 = \"$WHITE\"
overlay1 = \"$WHITE\"
overlay2 = \"$WHITE\"
red = \"$RED\"
maroon = \"$BRIGHT_RED\"
green = \"$GREEN\"
yellow = \"$YELLOW\"
peach = \"$YELLOW\"
blue = \"$BLUE\"
sapphire = \"$BRIGHT_BLUE\"
sky = \"$CYAN\"
teal = \"$CYAN\"
cyan = \"$BRIGHT_CYAN\"
lavender = \"$MAGENTA\"
purple = \"$MAGENTA\"
pink = \"$BRIGHT_MAGENTA\"
flamingo = \"$BRIGHT_MAGENTA\"
rosewater = \"$BRIGHT_WHITE\"
orange = \"$YELLOW\"
# END OMARCHY PALETTE"

  # Replace palette section between markers
  # Use perl for multi-line replacement
  perl -i -0pe "s/# BEGIN OMARCHY PALETTE.*?# END OMARCHY PALETTE/$PALETTE_CONTENT/s" "$STARSHIP_CONFIG"

  # Update palette reference
  sed -i "s/^palette = .*/palette = 'omarchy'/" "$STARSHIP_CONFIG"

  echo "✓ Starship config updated with $THEME_NAME theme"
fi

#
# UPDATE TMUX
#
# Generate tmux colors file with Catppuccin variable overrides
cat >"$TMUX_COLORS_FILE" <<EOF
# Omarchy theme: $THEME_NAME (auto-generated)
# Override Catppuccin @thm_* variables

# Primary colors
set -g @thm_bg "$BG"
set -g @thm_fg "$FG"

# Base ANSI colors
set -g @thm_red "$RED"
set -g @thm_green "$GREEN"
set -g @thm_yellow "$YELLOW"
set -g @thm_blue "$BLUE"
set -g @thm_cyan "$CYAN"
set -g @thm_magenta "$MAGENTA"

# Extended Catppuccin colors
set -g @thm_pink "$BRIGHT_MAGENTA"
set -g @thm_mauve "$MAGENTA"
set -g @thm_lavender "$BRIGHT_BLUE"
set -g @thm_sky "$CYAN"
set -g @thm_sapphire "$BRIGHT_BLUE"
set -g @thm_teal "$CYAN"
set -g @thm_peach "$BRIGHT_YELLOW"
set -g @thm_maroon "$RED"
set -g @thm_rosewater "$BRIGHT_WHITE"
set -g @thm_flamingo "$BRIGHT_MAGENTA"
set -g @thm_orange "$YELLOW"

# Surface colors (darker backgrounds)
set -g @thm_crust "$BLACK"
set -g @thm_mantle "$BLACK"
set -g @thm_surface_0 "$BLACK"
set -g @thm_surface_1 "$BLACK"
set -g @thm_surface_2 "$BLACK"

# Text overlay colors
set -g @thm_overlay_0 "$WHITE"
set -g @thm_overlay_1 "$WHITE"
set -g @thm_overlay_2 "$WHITE"
set -g @thm_subtext_0 "$WHITE"
set -g @thm_subtext_1 "$BRIGHT_WHITE"
set -g @thm_text "$FG"
EOF

# Reload tmux sessions if running
if tmux list-sessions &>/dev/null 2>&1; then
  tmux source-file ~/.tmux.conf
  tmux display-message "Theme updated: $THEME_NAME" 2>/dev/null || true
  echo "✓ Tmux sessions reloaded with $THEME_NAME theme"
else
  echo "✓ Tmux colors updated (no sessions running)"
fi
