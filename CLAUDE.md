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

This is a single-host NixOS flake configuration for a gaming/desktop system named "jboedesk". The architecture follows NixOS flake conventions:

- `flake.nix` - Main flake definition with inputs (nixpkgs stable/unstable, home-manager) and outputs
- `hosts/jboedesk/` - Host-specific configuration
  - `configuration.nix` - Main system configuration (NVIDIA drivers, GNOME desktop, user accounts)
  - `hardware-configuration.nix` - Hardware-specific settings (currently deleted in working tree)
- `modules/` - Directory for modular configuration files (e.g., steam.nix, zen-browser.nix, gnome.nix)
- `home/` - Directory for home-manager configurations
  - `home.nix` - Main home-manager configuration for user "jboe"

The system is configured for:
- NVIDIA graphics with proprietary drivers
- GNOME desktop environment with GDM
- Gaming-focused setup with stable NixOS 25.05
- Flakes and nix-command experimental features enabled

The configuration uses both stable (25.05) and unstable nixpkgs channels, with unstable packages available via `pkgs-unstable` specialArg.

## Configuration Philosophy

**Modularity Focus**: This configuration emphasizes modularity and separation of concerns. When adding new functionality:
- Create separate module files in `modules/` directory for distinct features (e.g., steam.nix, zen-browser.nix, gnome.nix)
- Import these modules in `hosts/jboedesk/configuration.nix` using relative paths
- Keep the main configuration.nix focused on core system settings
- Group related packages and services together in logical modules

## Common Issues and Solutions

### Git Add Before Flake Check
**CRITICAL**: Always run `git add` for new files before running `nix flake check`. Flakes only include tracked files in their evaluation, so untracked files will cause "path does not exist" errors.

Workflow for new modules:
1. Create the module file (e.g., `modules/new-feature.nix`)
2. Import it in `configuration.nix`
3. **IMMEDIATELY** run `git add modules/new-feature.nix`
4. Then run `nix flake check` to validate
5. Apply with `sudo nixos-rebuild switch --flake .#jboedesk`

## Version-Specific Guidelines

**IMPORTANT**: This system uses NixOS 25.05. Only provide recommendations, code, and configuration suggestions that are compatible with NixOS 25.05. Always verify that suggested options, syntax, and module paths are current for this version before recommending them.