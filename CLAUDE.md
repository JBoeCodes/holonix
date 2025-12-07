# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Critical: Host Detection

**ALWAYS CHECK WHICH HOST IS BEING USED**: This repository contains configurations for multiple hosts:
- `jboedesk` - Desktop/gaming system with Intel CPU and NVIDIA graphics
- `jboebook` - Laptop system with Intel CPU
- `nixpad` - Laptop system with Intel CPU
- `jboeimac` - 2015 iMac 27" system with Intel CPU and AMD graphics (template configuration)

Before making ANY changes or recommendations:
1. Check the current hostname with `hostname` command
2. Verify which host configuration to modify in `hosts/` directory
3. Use the correct host name in rebuild commands: `.#jboedesk`, `.#jboebook`, `.#nixpad`, or `.#jboeimac`
4. Be aware that hardware configurations differ between hosts (e.g., graphics drivers, laptop-specific tools)

## Critical: Version Verification

**MANDATORY VERSION CHECKS BEFORE ANY CONFIGURATION CHANGES**: Before making ANY configuration changes or recommendations, you MUST verify that the options, syntax, and features you suggest are compatible with the EXACT versions being used:

### Required Version Checks:
1. **NixOS Version**: Run `nixos-version` to confirm the exact NixOS version
2. **Package/Service Versions**: For any package or service being configured (e.g., Hyprland, GNOME, etc.), check its version:
   - For running services: Use service-specific version commands (e.g., `hyprctl version` for Hyprland)
   - For packages: Check with `nix-env -q` or inspect the flake inputs
3. **Home-Manager Version**: Verify from `flake.nix` inputs (release-25.11)

### Verification Workflow (MANDATORY):
1. **Before suggesting ANY configuration option**:
   - Check the current versions using the commands above
   - Use WebSearch to verify the option exists in that EXACT version
   - Look for official documentation, release notes, or configuration examples for that version

2. **When searching for configuration options**:
   - Include the specific version number in your search query
   - Example: "Hyprland 0.52 disable ecosystem news" NOT just "Hyprland disable news"

3. **If you cannot verify an option exists**:
   - DO NOT guess or assume the option exists
   - DO NOT suggest configuration changes without verification
   - Use WebSearch or ask the user for clarification

### Why This Matters:
- Configuration options change between versions
- Using incorrect options causes build/runtime errors
- The user expects configurations to work on the first try
- Failed rebuilds waste time and can break the system

**CRITICAL**: Always verify BEFORE editing configuration files. Never make changes based on assumptions or outdated documentation.

## System Management Commands

This is a NixOS configuration managed with flakes. Key commands for system management:

**For jboedesk (desktop):**
- `sudo nixos-rebuild switch --flake .#jboedesk` - Apply configuration changes and switch to the new generation
- `sudo nixos-rebuild test --flake .#jboedesk` - Test configuration without making it the default boot option
- `sudo nixos-rebuild boot --flake .#jboedesk` - Apply changes but only activate on next boot

**For jboebook (laptop):**
- `sudo nixos-rebuild switch --flake .#jboebook` - Apply configuration changes and switch to the new generation
- `sudo nixos-rebuild test --flake .#jboebook` - Test configuration without making it the default boot option
- `sudo nixos-rebuild boot --flake .#jboebook` - Apply changes but only activate on next boot

**For nixpad (laptop):**
- `sudo nixos-rebuild switch --flake .#nixpad` - Apply configuration changes and switch to the new generation
- `sudo nixos-rebuild test --flake .#nixpad` - Test configuration without making it the default boot option
- `sudo nixos-rebuild boot --flake .#nixpad` - Apply changes but only activate on next boot

**For jboeimac (iMac):**
- `sudo nixos-rebuild switch --flake .#jboeimac` - Apply configuration changes and switch to the new generation
- `sudo nixos-rebuild test --flake .#jboeimac` - Test configuration without making it the default boot option
- `sudo nixos-rebuild boot --flake .#jboeimac` - Apply changes but only activate on next boot

**Common commands (all hosts):**
- `nix flake update` - Update flake inputs (nixpkgs, home-manager, etc.)
- `nix flake check` - Validate flake configuration

**CRITICAL**: Always run `git add` for new files before running `nix flake check`. Flakes only include tracked files in their evaluation.

## Architecture

This is a multi-host NixOS flake configuration managing four systems: jboedesk (desktop), jboebook (laptop), nixpad (laptop), and jboeimac (iMac). The architecture follows NixOS flake conventions with extreme modularity:

### Core Structure

- `flake.nix` - Main flake definition
  - Inputs: nixpkgs (25.11), nixpkgs-unstable, home-manager (25.11)
  - Outputs: Four nixosConfigurations, one for each host
  - All hosts use home-manager as a NixOS module
  - Unstable packages available via `pkgs-unstable` specialArg

- `hosts/` - Host-specific configurations (minimal, hostname only)
  - `jboedesk/` - Desktop system
    - `configuration.nix` - Hostname and imports only
    - `packages.nix` - Minimal system packages (git, zsh)
    - `hardware-configuration.nix` - Auto-generated hardware scan
  - `jboebook/` - Laptop system
    - `configuration.nix` - Hostname and imports only
    - `packages.nix` - System packages including laptop tools (brightnessctl, acpi)
    - `hardware-configuration.nix` - Auto-generated hardware scan
  - `nixpad/` - Laptop system
    - `configuration.nix` - Hostname and imports only
    - `packages.nix` - Desktop environment packages (VSCode, Firefox, etc.)
    - `hardware-configuration.nix` - Auto-generated hardware scan
  - `jboeimac/` - iMac system (template)
    - `configuration.nix` - Hostname and imports only
    - `packages.nix` - Minimal system packages (git, zsh)
    - `hardware-configuration.nix` - Template (needs actual hardware scan)

### Module Organization

- `modules/default.nix` - Central module index that imports ALL modules
  - **Config modules** (`config/`)
    - `fonts.nix` - Hack Nerd Font installation
    - `locale.nix` - Timezone (America/New_York), locales, keyboard layout (US)
    - `user.nix` - User account (jboe) with zsh shell

  - **Display modules** (`display/`)
    - `gnome.nix` - GNOME Desktop Environment with extensive application suite
      - Conditionally enabled for all four hosts
      - Includes GNOME core apps, system tools, and customization packages
      - Wayland support enabled by default
      - Qt theming configured to match GNOME (Adwaita)
      - XDG portal configuration
      - Location services (geoclue2)

  - **Hardware modules** (`hardware/`)
    - `audio.nix` - PipeWire audio system (replaces PulseAudio)
    - `nvidia.nix` - NVIDIA graphics drivers (conditional for jboedesk only)
      - Stable drivers, modesetting enabled, proprietary drivers
      - 32-bit support for gaming

  - **Network modules** (`network/`)
    - `networking.nix` - NetworkManager configuration
    - `smb.nix` - CIFS/SMB support with gvfs

  - **System modules** (`system/`)
    - `boot.nix` - Systemd-boot with quiet boot parameters
    - `nix.nix` - Flakes and nix-command experimental features, unfree packages
    - `printing.nix` - CUPS printing services
    - `steam.nix` - Steam with remote play and local network game transfers

  - **Tools modules** (`tools/`)
    - Currently empty (git-repos.nix removed based on git status)

### Home Manager Configuration

- `home/home.nix` - Main home-manager configuration
  - Imports three modular configurations
  - Shared across all four hosts
  - State version: 25.05

- `home/modules/` - User-level modular configurations
  - `alacritty.nix` - Terminal emulator with custom theme
    - 80% opacity, no decorations
    - Gruvbox-inspired color scheme
    - Hack Nerd Font Mono
    - Custom keybindings (Ctrl+N for new instance)

  - `packages.nix` - User packages managed by home-manager
    - Development: neovim, claude-code, VSCode
    - Browsers: brave (default), firefox
    - Media: spotify, strawberry, cmus, mpv
    - Utilities: obsidian, parsec-bin, ventoy
    - Modern CLI tools: bat, eza, fd, btop, fastfetch, dust, zoxide, fzf
    - Media processing: imagemagick, ffmpeg
    - Nix formatting: nixfmt-classic
    - Default browser set to Brave via XDG MIME associations

  - `zsh.nix` - Zsh configuration with Oh My Zsh
    - Theme: robbyrussell
    - Plugins: git, sudo, history-substring-search, colored-man-pages, command-not-found
    - Modern CLI aliases: eza for ls, bat for cat, fd for find, z for cd
    - System aliases: btop for htop, fastfetch for neofetch
    - NixOS-specific aliases: nrs, nrt, nrb, nfu, nfc
    - nixai alias for AI-assisted config editing (cd ~/nixos && claude)
    - Zoxide integration for smart directory navigation
    - Note: Host-specific aliases in initContent reference "nixpad" - should be updated per host

## System Configuration Details

### NixOS Version
- **Current Version**: NixOS 25.11 (updated from 25.05)
- **State Versions**:
  - jboedesk: 25.11
  - jboebook: 25.05
  - nixpad: 25.05
  - jboeimac: 25.05
- **Channels**:
  - Stable: nixos-25.11
  - Unstable: nixos-unstable (available as pkgs-unstable)

### Key Features
- GNOME desktop environment (all hosts)
- PipeWire audio system
- NVIDIA graphics (jboedesk only, with 32-bit support)
- Steam gaming platform with network features
- SMB/CIFS network share support
- Quiet boot with reduced verbosity
- Home-manager integrated as NixOS module
- Unfree packages enabled
- Flakes and nix-command experimental features

### Hardware Differences
- **jboedesk**: Desktop/gaming, Intel CPU, NVIDIA GPU
- **jboebook**: Laptop, Intel CPU, includes laptop tools (brightnessctl, acpi)
- **nixpad**: Laptop, Intel CPU, includes desktop environment packages
- **jboeimac**: iMac template, Intel CPU, AMD GPU (not yet configured)

## Configuration Philosophy

**STRICT MODULARITY REQUIREMENT**: This configuration REQUIRES extreme modularity and separation of concerns. When adding ANY new functionality:

### Module Creation Rules
- **NEVER add functionality to existing files unless it's directly related**: Always create new module files
- **ALWAYS create separate modules**: Even for simple configurations, create dedicated module files in the appropriate `modules/` subdirectory
- **MANDATORY category organization**:
  - `config/` - System-wide configuration (users, locales, fonts)
  - `display/` - Desktop environments and display managers
  - `hardware/` - Hardware-specific configurations (graphics, audio)
  - `network/` - Networking and connectivity (including SMB, VPN, etc.)
  - `system/` - Core system services (boot, nix settings, printing, gaming)
  - `tools/` - Application-specific configurations
- **ALWAYS import through modules/default.nix**: Add new modules to the central index, never directly in configuration.nix
- **Keep ALL configuration files minimal**: Every file should focus on one specific area of functionality
- **Break down large configurations**: If a module grows beyond 50-100 lines, consider splitting it further
- **Use home-manager for user-specific configurations**: Dotfiles, user programs, and personal settings belong in `home/modules/`
- **The user prefers over-modularization to under-modularization**: When in doubt, create a separate module

### Host-Specific Configuration
- **Host configuration files** (`hosts/*/configuration.nix`) should ONLY contain:
  - Import statements (hardware-configuration.nix, packages.nix, modules/default.nix)
  - Hostname declaration
  - System state version
  - NO other configuration - everything else goes in modules
- **Host packages** (`hosts/*/packages.nix`) should contain:
  - Minimal system-wide packages required for that specific host
  - Laptop-specific tools for laptop hosts (brightnessctl, acpi)
  - Host-specific applications if needed
- **Shared modules** use conditional logic (lib.mkIf) to enable/disable per host

### Workflow for Adding New Modules

1. **FIRST** check which host you're working with using `hostname`
2. Create the module file in the appropriate category (e.g., `modules/hardware/new-device.nix`)
3. Import it in `modules/default.nix` under the correct category section
4. **IMMEDIATELY** run `git add modules/category/new-module.nix`
5. Run `nix flake check` to validate
6. **DO NOT** rebuild - prompt the user to rebuild with correct host

## Version-Specific Guidelines

**IMPORTANT**: This system uses NixOS 25.11. Only provide recommendations, code, and configuration suggestions that are compatible with NixOS 25.11. Always verify that suggested options, syntax, and module paths are current for this version before recommending them.

**Never attempt to rebuild** - instead prompt the user to rebuild with the appropriate command for their host.

## Common Issues

### Git Add Before Flake Check
Always run `git add` for new files before running `nix flake check`. Flakes only include tracked files in their evaluation, so untracked files will cause "path does not exist" errors.

### Host-Specific Aliases
The zsh configuration in `home/modules/zsh.nix` contains host-specific aliases (nrs, nrt, nrb) that reference "nixpad". These should ideally be updated per host or made dynamic.

### iMac Configuration Incomplete
The jboeimac configuration is currently a template with placeholder UUIDs in the hardware-configuration.nix. This host needs actual hardware scan results before it can be used.
