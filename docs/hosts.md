# Host Configurations

Documentation for all four host systems in this configuration.

## Overview

| Host | Type | CPU | GPU | Status | State Version |
|------|------|-----|-----|--------|---------------|
| jboedesk | Desktop/Gaming | Intel | NVIDIA | Active | 25.11 |
| jboebook | Laptop | Intel | Integrated | **Current** | 25.05 |
| nixpad | Laptop | Intel | Integrated | Active | 25.05 |
| jboeimac | iMac 27" | Intel | AMD | Template | 25.05 |

## Host Detection

**ALWAYS** check which host you're working on before making changes:
```bash
hostname
```

## jboedesk (Desktop/Gaming)

### Hardware
- **Type**: Desktop system
- **CPU**: Intel
- **GPU**: NVIDIA (proprietary drivers enabled)
- **Form Factor**: Desktop

### Configuration
- **Location**: `hosts/jboedesk/`
- **State Version**: 25.11
- **Rebuild Command**: `sudo nixos-rebuild switch --flake .#jboedesk`

### Special Features
- NVIDIA graphics drivers with 32-bit support
- Steam gaming platform
- High-performance configuration
- Desktop-optimized settings

### Hardware Configuration
Auto-generated from hardware scan. Contains:
- Boot loader settings
- Filesystem mounts
- Hardware-specific kernel modules

### System Packages
Minimal system packages (defined in `packages.nix`):
- git
- zsh

## jboebook (Laptop) **[CURRENT HOST]**

### Hardware
- **Type**: Laptop
- **CPU**: Intel
- **GPU**: Intel Integrated
- **Form Factor**: Laptop

### Configuration
- **Location**: `hosts/jboebook/`
- **State Version**: 25.05
- **Rebuild Command**: `sudo nixos-rebuild switch --flake .#jboebook`

### Special Features
- Laptop power management
- Battery monitoring
- Touchpad support with natural scrolling
- Brightness controls

### Laptop-Specific Tools
Additional packages in `packages.nix`:
- `brightnessctl` - Screen brightness control
- `acpi` - Battery and power information

### Display Configuration
- Hyprland scale: 1.6 (for laptop display)
- Monitor config: `monitor = ,preferred,auto,1.6`

### Hardware Configuration
Auto-generated. Key features:
- Battery support
- Laptop-specific kernel modules
- Power management

## nixpad (Laptop)

### Hardware
- **Type**: Laptop
- **CPU**: Intel
- **GPU**: Intel Integrated
- **Form Factor**: Laptop

### Configuration
- **Location**: `hosts/nixpad/`
- **State Version**: 25.05
- **Rebuild Command**: `sudo nixos-rebuild switch --flake .#nixpad`

### Special Features
- Full desktop environment package set
- Development tools
- Media applications

### System Packages
More extensive package list (defined in `packages.nix`):
- Desktop environment apps (VSCode, Firefox)
- Development tools
- Media applications
- Full productivity suite

### Notes
- More complete package installation than other hosts
- Configured as primary development machine
- Full suite of GUI applications

## jboeimac (iMac Template)

### Hardware
- **Type**: iMac 27" (2015)
- **CPU**: Intel
- **GPU**: AMD
- **Form Factor**: All-in-one desktop

### Configuration
- **Location**: `hosts/jboeimac/`
- **State Version**: 25.05
- **Rebuild Command**: `sudo nixos-rebuild switch --flake .#jboeimac`

### Status
**⚠️ INCOMPLETE CONFIGURATION**

This is currently a template configuration:
- Hardware configuration has placeholder UUIDs
- Needs actual hardware scan: `nixos-generate-config`
- AMD graphics drivers not yet configured
- Not ready for deployment

### Required Setup
Before this host can be used:

1. Boot NixOS installer on the iMac
2. Generate hardware config:
   ```bash
   nixos-generate-config --show-hardware-config > hardware-configuration.nix
   ```
3. Copy real hardware config to `hosts/jboeimac/hardware-configuration.nix`
4. Configure AMD graphics drivers
5. Test and validate

### System Packages
Minimal system packages (same as jboedesk):
- git
- zsh

## Shared Configuration

All hosts share:

### Desktop Environment
- Hyprland (Wayland compositor)
- GNOME Desktop (conditionally available)

### Common Modules
All enabled via `modules/default.nix`:
- Fonts (Hack Nerd Font)
- Locale settings (America/New_York, US keyboard)
- User account (jboe with zsh)
- Audio (PipeWire)
- Networking (NetworkManager)
- SMB/CIFS support
- Boot configuration (systemd-boot)
- Printing (CUPS)

### Home Manager
Same home configuration for all hosts:
- Shared user packages
- Common shell configuration
- Unified Hyprland setup
- Shared dotfiles

## Host-Specific Conditionals

Some modules use conditionals for host-specific features:

### NVIDIA Graphics (jboedesk only)
```nix
programs.nvidia.enable = lib.mkIf (config.networking.hostName == "jboedesk") true;
```

### GNOME Desktop (all hosts)
Enabled for all four hosts but can be conditionally disabled.

## Adding a New Host

To add a new host to this configuration:

1. **Create host directory**:
   ```bash
   mkdir -p hosts/newhostname
   ```

2. **Create configuration.nix**:
   ```nix
   { config, pkgs, ... }:
   {
     imports = [
       ./hardware-configuration.nix
       ./packages.nix
       ../../modules/default.nix
     ];

     networking.hostName = "newhostname";
     system.stateVersion = "25.11";
   }
   ```

3. **Generate hardware config**:
   ```bash
   nixos-generate-config --show-hardware-config > hosts/newhostname/hardware-configuration.nix
   ```

4. **Create packages.nix**:
   ```nix
   { config, pkgs, ... }:
   {
     environment.systemPackages = with pkgs; [
       git
       zsh
     ];
   }
   ```

5. **Add to flake.nix**:
   ```nix
   nixosConfigurations.newhostname = nixpkgs.lib.nixosSystem {
     # ... same pattern as other hosts
   };
   ```

6. **Customize as needed**:
   - Add host-specific packages to packages.nix
   - Add conditionals for hardware features
   - Configure display settings

## Rebuild Commands Reference

| Host | Command |
|------|---------|
| jboedesk | `sudo nixos-rebuild switch --flake .#jboedesk` |
| jboebook | `sudo nixos-rebuild switch --flake .#jboebook` |
| nixpad | `sudo nixos-rebuild switch --flake .#nixpad` |
| jboeimac | `sudo nixos-rebuild switch --flake .#jboeimac` |

### Alternative Rebuild Options
- `switch` - Apply and set as default boot
- `test` - Apply but don't set as default
- `boot` - Set for next boot only

## Common Issues

### Wrong Host Selected
**Symptom**: Building for wrong host
**Solution**: Always check `hostname` first, use correct `.#hostname` in rebuild command

### Hardware Config Conflicts
**Symptom**: Boot fails after rebuild
**Solution**: Ensure `hardware-configuration.nix` matches actual hardware

### Host-Specific Features Not Working
**Symptom**: Feature works on one host but not another
**Solution**: Check for host-specific conditionals, verify packages.nix includes required tools
