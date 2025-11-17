# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Critical: Host Detection

**ALWAYS CHECK WHICH HOST IS BEING USED**: This repository contains configurations for multiple hosts:
- `jboedesk` - Gaming/desktop system with NVIDIA graphics and KDE Plasma
- `jboebook` - Laptop system with GNOME desktop environment

Before making ANY changes or recommendations:
1. Check the current hostname with `hostname` command
2. Verify which host configuration to modify in `hosts/` directory
3. Use the correct host name in rebuild commands: `.#jboedesk` or `.#jboebook`
4. Be aware that hardware configurations differ between hosts (e.g., graphics drivers, power management)

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

**Common commands (all hosts):**
- `nix flake update` - Update flake inputs (nixpkgs, home-manager, etc.)
- `nix flake check` - Validate flake configuration

## Architecture

This is a multi-host NixOS flake configuration managing both "jboedesk" (gaming/desktop) and "jboebook" (laptop) systems. The architecture follows NixOS flake conventions with a highly modular structure:

- `flake.nix` - Main flake definition with inputs (nixpkgs stable/unstable, home-manager) and outputs
- `hosts/` - Host-specific configurations
  - `jboedesk/` - Desktop/gaming system configuration
    - `configuration.nix` - Main configuration file that imports hardware scan, packages, and modules
    - `packages.nix` - System packages definition
    - `hardware-configuration.nix` - Hardware-specific settings
  - `jboebook/` - Laptop system configuration
    - `configuration.nix` - Main configuration file that imports hardware scan, packages, and modules
    - `packages.nix` - System packages definition
    - `hardware-configuration.nix` - Hardware-specific settings
- `modules/` - Highly modular configuration directory organized by category:
  - `default.nix` - Central module index that imports all component modules
  - `config/` - System configuration modules
    - `locale.nix` - Timezone, locales, and keyboard layout
    - `user.nix` - User account definitions
  - `display/` - Desktop environment modules
    - `kde-plasma.nix` - KDE Plasma desktop configuration (jboedesk)
    - `gnome.nix` - GNOME desktop configuration (jboebook)
  - `hardware/` - Hardware-specific modules
    - `audio.nix` - PipeWire audio system and printing
    - `nvidia.nix` - NVIDIA graphics drivers and settings
    - `vr.nix` - VR configuration with Monado runtime and SteamVR compatibility
  - `network/` - Networking modules
    - `networking.nix` - Hostname and NetworkManager configuration
    - `smb.nix` - SMB/CIFS support and utilities
  - `system/` - Core system modules
    - `boot.nix` - Systemd-boot bootloader configuration
    - `nix.nix` - Nix settings and unfree package allowance
    - `steam.nix` - Gaming platform configuration
    - `storage.nix` - Storage and filesystem configuration
  - `tools/` - Application-specific modules
    - `zen-browser.nix` - Zen browser integration
- `home/` - Directory for home-manager configurations
  - `home.nix` - Main home-manager configuration for user "jboe"
  - `packages.nix` - User-specific packages including development tools
  - `vr.nix` - User-level VR configuration for OpenVR runtime settings
  - `zsh.nix` - Zsh shell configuration with Oh My Zsh

The system is configured for:
- NVIDIA graphics with proprietary drivers (jboedesk)
- KDE Plasma desktop environment (jboedesk) / GNOME desktop environment (jboebook)
- Gaming-focused setup with stable NixOS 25.05
- VR gaming with Monado OpenXR runtime and SteamVR compatibility
- Flakes and nix-command experimental features enabled

The configuration uses both stable (25.05) and unstable nixpkgs channels, with unstable packages available via `pkgs-unstable` specialArg. Home-manager is integrated as a NixOS module for user-specific configurations.

## Configuration Philosophy

**STRICT MODULARITY REQUIREMENT**: This configuration REQUIRES extreme modularity and separation of concerns. The user has repeatedly emphasized the importance of breaking functionality into separate, organized modules. When adding ANY new functionality:

- **NEVER add functionality to existing files unless it's directly related**: Always create new module files
- **ALWAYS create separate modules**: Even for simple configurations, create dedicated module files in the appropriate `modules/` subdirectory
- **MANDATORY category organization**:
  - `config/` - System-wide configuration (users, locales, etc.)
  - `display/` - Desktop environments and display managers
  - `hardware/` - Hardware-specific configurations (graphics, audio, etc.)
  - `network/` - Networking and connectivity (including SMB, VPN, etc.)
  - `system/` - Core system services (boot, nix settings, storage, etc.)
  - `tools/` - Application-specific configurations
- **ALWAYS import through modules/default.nix**: Add new modules to the central index, never directly in configuration.nix
- **Keep ALL configuration files minimal**: Every file should focus on one specific area of functionality
- **Break down large configurations**: If a module grows beyond 50-100 lines, consider splitting it further
- **Use home-manager for user-specific configurations**: Dotfiles, user programs, and personal settings belong in home/
- **The user prefers over-modularization to under-modularization**: When in doubt, create a separate module

## Common Issues and Solutions

### Git Add Before Flake Check
**CRITICAL**: Always run `git add` for new files before running `nix flake check`. Flakes only include tracked files in their evaluation, so untracked files will cause "path does not exist" errors.

Workflow for new modules:
1. **FIRST** check which host you're working with using `hostname`
2. Create the module file in the appropriate category (e.g., `modules/hardware/new-device.nix`)
3. Import it in `modules/default.nix` under the correct category section
4. **IMMEDIATELY** run `git add modules/category/new-module.nix`
5. Then run `nix flake check` to validate
6. Apply with the correct host: `sudo nixos-rebuild switch --flake .#jboedesk` OR `sudo nixos-rebuild switch --flake .#jboebook`

### SteamVR Configuration
The VR setup includes both system-level (`modules/hardware/vr.nix`) and user-level (`home/vr.nix`) configurations:
- **System**: Monado OpenXR runtime, udev rules for VR devices, polkit rules for setcap operations, realtime scheduling
- **User**: OpenVR runtime configuration, VR session variables
- **Key Fix**: Polkit rules allow SteamVR vrcompositor setcap operations to resolve "pkexec must be setuid root" errors

#### Common SteamVR Issues and Solutions

**Issue 1: OpenComposite "not-yet-ported-to-Linux" Error**
- **Symptoms**: SteamVR fails with error about stubbed functions in OCOVR/openvr_api.cpp
- **Root Cause**: `VR_OVERRIDE` environment variable forces OpenComposite usage, but OpenComposite has incomplete Linux support
- **Solution**: Remove/disable OpenComposite from configuration:
  - Remove `opencomposite` package from `modules/hardware/vr.nix`
  - Comment out `VR_OVERRIDE` in `home/vr.nix`
  - Use clean launch script: `/home/jboe/launch-steamvr-clean.sh`
  - **Critical**: Log out/restart after rebuild to clear old environment variables

**Issue 2: "SteamVR requires superuser access" Permission Errors**  
- **Symptoms**: SteamVR asks for sudo access, setup incomplete errors
- **Root Cause**: vrcompositor needs CAP_SYS_NICE capability for real-time scheduling
- **Solution**: Set capabilities manually: `sudo /home/jboe/fix-vr-permissions.sh`
- **Verification**: `getcap ~/.steam/steam/steamapps/common/SteamVR/bin/linux64/vrcompositor` should show `cap_sys_nice=ep`

**Issue 3: Wrong OpenVR Runtime Path**
- **Symptoms**: SteamVR can't find runtime, path errors
- **Root Cause**: OpenVR configuration points to wrong Steam path
- **Solution**: Ensure `~/.config/openvr/openvrpaths.vrpath` contains:
  ```json
  "runtime": ["/home/jboe/.steam/steam/steamapps/common/SteamVR"]
  ```

**Issue 4: Environment Variable Persistence**
- **Symptoms**: Old VR_OVERRIDE values persist even after NixOS rebuild
- **Root Cause**: Current session retains old environment variables
- **Solution**: Use clean launch script or log out/restart session

**Troubleshooting Scripts Available:**
- `/home/jboe/test-vr-permissions.sh` - Diagnose permission issues
- `/home/jboe/fix-vr-permissions.sh` - Fix VR compositor capabilities  
- `/home/jboe/fix-steamvr-complete.sh` - Complete SteamVR diagnostic and fix
- `/home/jboe/launch-steamvr-clean.sh` - Launch Steam with clean VR environment

**Working Configuration:**
- Monado as OpenXR runtime (`services.monado.enable = true`)
- SteamVR as OpenVR runtime (no OpenComposite override)
- Proper udev rules for VR device access
- CAP_SYS_NICE on vrcompositor for real-time scheduling
- Polkit rules for automated privilege escalation

## Version-Specific Guidelines

**IMPORTANT**: This system uses NixOS 25.05. Only provide recommendations, code, and configuration suggestions that are compatible with NixOS 25.05. Always verify that suggested options, syntax, and module paths are current for this version before recommending them.
- never attempt to rebuild, instead prompt me to rebuild