# System Overview

## Architecture

This is a multi-host NixOS flake configuration managing four systems with extreme modularity.

### Core Structure

```
nixos/
├── flake.nix                 # Main flake definition
├── flake.lock               # Locked dependency versions
├── hosts/                   # Host-specific configurations
│   ├── jboedesk/           # Desktop system
│   ├── jboebook/           # Laptop system (current)
│   ├── nixpad/             # Laptop system
│   └── jboeimac/           # iMac (template)
├── modules/                 # Shared system modules
│   ├── default.nix         # Module index
│   ├── config/             # System configuration
│   ├── display/            # Desktop environments
│   ├── hardware/           # Hardware configs
│   ├── network/            # Network settings
│   └── system/             # Core system services
├── home/                    # Home Manager configuration
│   ├── home.nix            # Main home config
│   └── modules/            # User-level modules
└── docs/                    # Documentation (this directory)
```

## Flake Configuration

### Inputs
- **nixpkgs** (25.11) - Stable channel
- **nixpkgs-unstable** - Latest packages when needed
- **home-manager** (25.11) - User environment management

### Outputs
Four NixOS configurations, one per host. All use:
- Home Manager as a NixOS module
- Unstable packages available via `pkgs-unstable` specialArg
- Shared module system via `modules/default.nix`

## Design Philosophy

### Strict Modularity

**CRITICAL**: This configuration requires extreme modularity:

1. **Never add functionality to existing files** unless directly related
2. **Always create separate modules** for new functionality
3. **Categorize properly** - Use the correct subdirectory in `modules/`
4. **Import through default.nix** - Never import directly in configuration.nix
5. **Keep files minimal** - Each file focuses on one specific area

### Module Categories

- **config/** - System-wide settings (users, locales, fonts)
- **display/** - Desktop environments and display managers
- **hardware/** - Hardware-specific configs (graphics, audio)
- **network/** - Networking and connectivity
- **system/** - Core system services (boot, nix, printing, gaming)
- **tools/** - Application-specific configurations

### Host-Specific Configuration

Host configuration files (`hosts/*/configuration.nix`) should ONLY contain:
- Import statements
- Hostname declaration
- System state version
- NO other configuration - everything else goes in modules

## Version Management

### Current Versions
- **NixOS**: 25.11
- **Home Manager**: 25.11 (release-25.11 branch)
- **State Versions**: Mixed (see hosts.md)

### Version Verification Workflow

**MANDATORY** before any configuration changes:

1. Check NixOS version: `nixos-version`
2. Check package versions (e.g., `hyprctl version`)
3. Verify options exist in documentation for EXACT version
4. Use WebSearch to confirm if uncertain

**Why this matters**:
- Configuration options change between versions
- Incorrect options cause build/runtime errors
- User expects configs to work on first try

## Home Manager Integration

Home Manager is integrated as a NixOS module (not standalone).

### Structure
```
home/
├── home.nix              # Main home config
└── modules/
    ├── alacritty.nix    # Terminal emulator
    ├── ghostty.nix      # Alternative terminal
    ├── packages.nix     # User packages
    ├── zsh.nix          # Shell configuration
    └── hypr/            # Hyprland-specific
        ├── hyprland.nix
        ├── waybar.nix
        ├── rofi.nix
        ├── wallpaper-picker.nix
        └── keybind-cheatsheet.nix
```

## Key Features

### Desktop Environment
- **Primary**: Hyprland (Wayland compositor)
- **Available**: GNOME Desktop (conditionally enabled)
- **Status Bar**: Waybar with custom theme
- **Launcher**: Rofi with Catppuccin theme
- **Terminal**: Ghostty (primary), Alacritty (available)

### Audio
- PipeWire (replaces PulseAudio)
- Full ALSA/JACK compatibility

### Graphics
- NVIDIA drivers (jboedesk only, with 32-bit support)
- Intel integrated graphics (laptops)

### Networking
- NetworkManager
- SMB/CIFS support with gvfs

### Boot
- systemd-boot bootloader
- Quiet boot with reduced verbosity
- Fast boot optimizations

### Gaming
- Steam with Remote Play
- NVIDIA 32-bit support
- Local network game transfers

## Package Management

### System Packages
- Defined in `hosts/*/packages.nix`
- Minimal per-host requirements
- Git and Zsh on all systems

### User Packages
- Defined in `home/modules/packages.nix`
- Managed by Home Manager
- Shared across all hosts
- Includes development tools, browsers, media apps

### Unfree Packages
Enabled system-wide via `modules/system/nix.nix`:
```nix
nixpkgs.config.allowUnfree = true;
```

## Git Integration

### Flake Requirements
**CRITICAL**: Always run `git add` for new files before `nix flake check`.

Flakes only include tracked files in evaluation. Untracked files cause "path does not exist" errors.

### Workflow
```bash
# 1. Create new module
vim modules/category/new-module.nix

# 2. Add to git immediately
git add modules/category/new-module.nix

# 3. Validate
nix flake check

# 4. Rebuild
sudo nixos-rebuild switch --flake .#hostname
```

## Common Patterns

### Adding a New Module

1. Create module file in appropriate category
2. Import in `modules/default.nix`
3. Run `git add` on new file
4. Validate with `nix flake check`
5. Rebuild on target host

### Adding a New Package

**System package**:
- Add to `hosts/hostname/packages.nix`

**User package**:
- Add to `home/modules/packages.nix`

### Conditional Configuration

Use `lib.mkIf` for host-specific features:
```nix
programs.nvidia.enable = lib.mkIf (config.networking.hostName == "jboedesk") true;
```

## Color Scheme

System uses Catppuccin Mocha theme:
- Background: `#1e1e2e`
- Background Alt: `#181825`
- Foreground: `#cdd6f4`
- Accent (Blue): `#89b4fa`
- Green: `#a6e3a1`
- Yellow: `#f9e2af`
- Red: `#f38ba8`

Applied consistently across:
- Waybar
- Rofi
- Hyprland borders
- Terminal themes
