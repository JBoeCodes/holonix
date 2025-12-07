# NixOS Multi-Host Flake Configuration

A highly modular NixOS flake configuration managing four systems with Hyprland, dynamic theming, and comprehensive documentation.

## 📋 Quick Start

### Check Your Current Host
```bash
hostname
```

### Apply Configuration Changes
```bash
# For jboebook (laptop)
sudo nixos-rebuild switch --flake .#jboebook

# For jboedesk (desktop)
sudo nixos-rebuild switch --flake .#jboedesk

# For nixpad (laptop)
sudo nixos-rebuild switch --flake .#nixpad

# For jboeimac (iMac - template only)
sudo nixos-rebuild switch --flake .#jboeimac
```

### Common Operations
```bash
# Test without making default
sudo nixos-rebuild test --flake .#hostname

# Update flake inputs
nix flake update

# Validate configuration
nix flake check
```

## 🖥️ Managed Hosts

| Host | Type | CPU | GPU | Status |
|------|------|-----|-----|--------|
| **jboebook** | Laptop | Intel | Integrated | ✅ Active (Current) |
| **jboedesk** | Desktop | Intel | NVIDIA | ✅ Active |
| **nixpad** | Laptop | Intel | Integrated | ✅ Active |
| **jboeimac** | iMac 27" | Intel | AMD | ⚠️ Template Only |

## ✨ Key Features

### Desktop Environment
- **Primary**: Hyprland (Wayland compositor)
  - Dynamic tiling window management
  - Aesthetic theme system with matugen
  - Custom waybar with system info
  - Rofi application launcher
- **Available**: GNOME Desktop (fallback)

### Theme System
- **Matugen Integration**: Auto-generates color schemes from wallpapers
- **Hot-Reload**: All apps update colors without restart
- **Unified Theming**: Hyprland, Waybar, Rofi, Kitty all sync

### Terminal Setup
- **Kitty**: Primary terminal with 75% transparency
- **Auto-Theming**: Colors update with wallpaper changes
- **Fastfetch**: System info with custom greeting on startup

### Audio & Graphics
- **Audio**: PipeWire with full ALSA/JACK support
- **Graphics**: NVIDIA drivers (jboedesk), Intel integrated (laptops)

### Development Tools
- Claude Code, VSCode, Neovim
- Modern CLI tools: bat, eza, fd, btop, zoxide, fzf
- Git workflow optimized

## 📁 Repository Structure

```
nixos/
├── flake.nix              # Main flake definition (4 hosts)
├── flake.lock             # Locked dependencies
├── CLAUDE.md              # AI assistant guidelines
├── README.md              # This file
├── docs/                  # 📚 Complete documentation
│   ├── README.md          # Documentation index
│   ├── modules.md         # Module reference
│   ├── hyprland.md        # Hyprland setup
│   ├── keybindings.md     # Keyboard shortcuts
│   ├── troubleshooting.md # Common issues
│   ├── workflows.md       # How-to guides
│   ├── hosts.md           # Host configurations
│   └── system-overview.md # Architecture details
├── hosts/                 # Host-specific configs
│   ├── jboedesk/         # Desktop system
│   ├── jboebook/         # Laptop system (current)
│   ├── nixpad/           # Laptop system
│   └── jboeimac/         # iMac template
├── modules/               # Shared system modules
│   ├── default.nix       # Central module index
│   ├── config/           # System config (fonts, locale, users)
│   ├── display/          # Desktop environments
│   ├── hardware/         # Hardware configs (audio, graphics)
│   ├── network/          # Networking (NetworkManager, SMB)
│   └── system/           # Core services (boot, nix, printing)
└── home/                  # Home Manager config
    ├── home.nix          # Main home config
    └── modules/          # User-level modules
        ├── kitty.nix     # Terminal emulator
        ├── zsh.nix       # Shell configuration
        ├── fastfetch.nix # System info display
        ├── packages.nix  # User packages
        └── hypr/         # Hyprland-specific
            ├── hyprland.nix
            ├── waybar.nix
            ├── rofi.nix
            ├── theme-picker.nix
            └── keybind-cheatsheet.nix
```

## 🎨 System Highlights

### Dynamic Theming
Change your entire desktop theme with one keystroke:
- **Super+Shift+W**: Visual wallpaper picker
- **Super+Ctrl+W**: Random wallpaper
- All colors auto-generated from wallpaper using Material Design 3 palette

### Hyprland Keybindings
- **Super+Space**: Application launcher
- **Super+K**: Keybinding cheatsheet
- **Super+Return**: Terminal
- **Super+[1-9]**: Switch workspaces
- See `docs/keybindings.md` for complete reference

### Shell Aliases
- `nrs`: nixos-rebuild switch
- `nrt`: nixos-rebuild test
- `nfu`: nix flake update
- `nfc`: nix flake check
- `nixai`: AI-assisted config editing

## 📚 Documentation

**Complete documentation available in `docs/` directory:**

- **[docs/README.md](docs/README.md)** - Start here for full documentation
- **[docs/modules.md](docs/modules.md)** - All modules explained
- **[docs/hyprland.md](docs/hyprland.md)** - Hyprland configuration
- **[docs/keybindings.md](docs/keybindings.md)** - All keyboard shortcuts
- **[docs/troubleshooting.md](docs/troubleshooting.md)** - Common issues
- **[docs/workflows.md](docs/workflows.md)** - How to perform common tasks
- **[docs/hosts.md](docs/hosts.md)** - Host-specific details

## 🏗️ Design Philosophy

### Strict Modularity
- Everything is separated into focused modules
- Never add functionality to existing files
- Always create new modules for new features
- Host configs contain only hostname and imports

### Reproducibility
- Flake-based for consistent builds
- All dependencies locked
- Declarative configuration
- Git-tracked for version control

### Multi-Host Support
- Shared configs with host-specific customization
- Conditional features (NVIDIA only on jboedesk)
- Per-host packages and settings

## 🔧 System Information

- **NixOS Version**: 25.11
- **Configuration Style**: Flakes with Home Manager
- **Home Manager**: Integrated as NixOS module
- **Unstable Packages**: Available via `pkgs-unstable`
- **State Versions**: Mixed (see docs/hosts.md)

## 🚀 Recent Updates

**2025-12-07**:
- Added fastfetch with custom greeting
- Fixed kitty theme auto-reloading
- Improved terminal transparency (75%)
- Fixed rofi theme validation
- Added complete documentation suite

See `docs/README.md` for full changelog.

## 🤝 Contributing & AI Assistance

This configuration is designed to work with Claude Code. See `CLAUDE.md` for:
- Mandatory version verification workflow
- Strict modularity requirements
- Host detection procedures
- Common patterns and best practices

## 📄 License

Personal configuration - use as reference for your own setup.

## 🔗 Links

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Hyprland Wiki](https://wiki.hyprland.org)
- [Repository](https://github.com/JBoeCodes/holonix)
