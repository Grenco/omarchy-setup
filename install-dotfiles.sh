#!/bin/sh

REPO_URL="https://github.com/Grenco/dotfiles"
REPO_NAME="dotfiles"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

is_stow_installed() {
  pacman -Qi "stow" &>/dev/null
}

if ! is_stow_installed; then
  echo "Install stow first"
  exit 1
fi

cd ~

# Check if the repository already exists
if [ -d "$REPO_NAME" ]; then
  echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
  git clone "$REPO_URL"
fi

# Check if the clone was successful
if [ $? -eq 0 ]; then
  echo "removing old configs"
  rm -rf ~/.config/nvim ~/.config/starship.toml ~/.config/kanata ~/.local/share/nvim/ ~/.cache/nvim/

  cd "$REPO_NAME"
  stow tmux
  stow nvim
  stow starship
  stow kanata

  echo ""
  echo "Installation complete!"

  # Check if Omarchy is installed
  if [ -e ~/.config/omarchy/current/theme/neovim.lua ]; then
    echo "✓ Omarchy detected - dynamic theming enabled (neovim + starship)"

    # Set up starship theme hook
    if [ -f "$SCRIPT_DIR/hooks/omarchy-starship-hook.sh" ]; then
      mkdir -p ~/.config/omarchy/hooks
      ln -sf "$SCRIPT_DIR/hooks/omarchy-starship-hook.sh" ~/.config/omarchy/hooks/theme-set
      chmod +x ~/.config/omarchy/hooks/theme-set
      echo "  → Starship theme hook installed"

      # Generate initial starship config with current theme
      ~/setup/hooks/omarchy-starship-hook.sh
    fi
  else
    echo "✓ Standalone mode - Tokyo Night (neovim), Catppuccin Mocha (starship)"
  fi
else
  echo "Failed to clone the repository."
  exit 1
fi
