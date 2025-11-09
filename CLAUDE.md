# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## System Management Commands

This is a NixOS configuration managed with flakes. Key commands for system management:

- `sudo nixos-rebuild switch --flake .#jboedesk` - Apply configuration changes and switch to the new generation
- `sudo nixos-rebuild test --flake .#jboedesk` - Test configuration without making it the default boot option
- `sudo nixos-rebuild boot --flake .#jboedesk` - Apply changes but only activate on next boot
- `nix flake update` - Update flake inputs (nixpkgs, home-manager, etc.)
- `nix flake check` - Validate flake configuration

## Architecture

This is a single-host NixOS flake configuration for a gaming/desktop system named "jboedesk". The architecture follows NixOS flake conventions with a highly modular structure:

- `flake.nix` - Main flake definition with inputs (nixpkgs stable/unstable, home-manager) and outputs
- `hosts/jboedesk/` - Host-specific configuration
  - `configuration.nix` - Minimal main configuration file that imports hardware scan, packages, and modules
  - `packages.nix` - System packages definition
  - `hardware-configuration.nix` - Hardware-specific settings (currently deleted in working tree)
- `modules/` - Highly modular configuration directory organized by category:
  - `default.nix` - Central module index that imports all component modules
  - `config/` - System configuration modules
    - `locale.nix` - Timezone, locales, and keyboard layout
    - `user.nix` - User account definitions
  - `display/` - Desktop environment modules
    - `kde-plasma.nix` - KDE Plasma desktop configuration
  - `hardware/` - Hardware-specific modules
    - `audio.nix` - PipeWire audio system and printing
    - `nvidia.nix` - NVIDIA graphics drivers and settings
  - `network/` - Networking modules
    - `networking.nix` - Hostname and NetworkManager configuration
  - `system/` - Core system modules
    - `boot.nix` - Systemd-boot bootloader configuration
    - `nix.nix` - Nix settings and unfree package allowance
    - `steam.nix` - Gaming platform configuration
    - `storage.nix` - Storage and filesystem configuration
  - `tools/` - Application-specific modules
    - `zen-browser.nix` - Zen browser integration
- `home/` - Directory for home-manager configurations
  - `home.nix` - Main home-manager configuration for user "jboe"

The system is configured for:
- NVIDIA graphics with proprietary drivers
- KDE Plasma desktop environment
- Gaming-focused setup with stable NixOS 25.05
- Flakes and nix-command experimental features enabled

The configuration uses both stable (25.05) and unstable nixpkgs channels, with unstable packages available via `pkgs-unstable` specialArg. Home-manager is integrated as a NixOS module for user-specific configurations.

## Configuration Philosophy

**Modularity Focus**: This configuration emphasizes modularity and separation of concerns. The system is organized into logical categories for maximum maintainability. When adding new functionality:

- **Always use the modular structure**: Create separate module files in the appropriate `modules/` subdirectory
- **Follow the category organization**:
  - `config/` - System-wide configuration (users, locales, etc.)
  - `display/` - Desktop environments and display managers
  - `hardware/` - Hardware-specific configurations (graphics, audio, etc.)
  - `network/` - Networking and connectivity
  - `system/` - Core system services (boot, nix settings, etc.)
  - `tools/` - Application-specific configurations
- **Import through modules/default.nix**: Add new modules to the central index rather than directly in configuration.nix
- **Keep configuration.nix minimal**: The main configuration file should only handle imports and host-specific overrides
- **Group related functionality**: Combine related packages and services in logical modules (e.g., audio.nix includes both PipeWire and printing)
- **Use home-manager for user-specific configurations**: Dotfiles, user programs, and personal settings belong in home/

## Common Issues and Solutions

### Git Add Before Flake Check
**CRITICAL**: Always run `git add` for new files before running `nix flake check`. Flakes only include tracked files in their evaluation, so untracked files will cause "path does not exist" errors.

Workflow for new modules:
1. Create the module file in the appropriate category (e.g., `modules/hardware/new-device.nix`)
2. Import it in `modules/default.nix` under the correct category section
3. **IMMEDIATELY** run `git add modules/category/new-module.nix`
4. Then run `nix flake check` to validate
5. Apply with `sudo nixos-rebuild switch --flake .#jboedesk`

## Version-Specific Guidelines

**IMPORTANT**: This system uses NixOS 25.05. Only provide recommendations, code, and configuration suggestions that are compatible with NixOS 25.05. Always verify that suggested options, syntax, and module paths are current for this version before recommending them.