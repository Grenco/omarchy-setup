# System Setup Scripts

Personal system configuration and installation scripts for Arch Linux with Omarchy.

## Overview

This repository contains scripts to automate the installation and configuration of my development environment, including:

- **Dotfiles management** - Stow-based dotfile installation
- **Window manager** - Hyprland configuration overrides
- **Keyboard remapping** - Kanata setup for custom key behaviors
- **Terminal multiplexer** - Tmux configuration
- **File manager** - Yazi setup
- **Theme integration** - Omarchy theme hooks

## Usage

Run the master installation script to set up everything:

```bash
./master-installation.sh
```

Individual scripts can also be run separately as needed.

## Structure

- `install-*.sh` - Installation scripts for specific tools
- `config/` - Configuration files
- `hooks/` - System hooks and integrations
- `master-installation.sh` - Main setup orchestrator
