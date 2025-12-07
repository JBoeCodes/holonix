# NixOS Configuration Documentation

Complete documentation for jboe's multi-host NixOS configuration.

## Quick Links

- [System Overview](system-overview.md) - Architecture and design philosophy
- [Host Configurations](hosts.md) - Details for each machine
- [Module Reference](modules.md) - Complete module documentation
- [Keybindings](keybindings.md) - All keyboard shortcuts
- [Troubleshooting](troubleshooting.md) - Common issues and solutions
- [Workflows](workflows.md) - How to perform common tasks
- [Hyprland Setup](hyprland.md) - Hyprland-specific configuration

## System Information

**NixOS Version**: 25.11
**Configuration Style**: Flakes with Home Manager
**Desktop Environment**: Hyprland (Wayland) with GNOME available
**Number of Hosts**: 4 (jboedesk, jboebook, nixpad, jboeimac)

## Recent Updates

**2025-12-07**
- Added fastfetch system info display with custom "Hello, Jameson" greeting
- Configured fastfetch to run automatically on shell startup
- Fixed kitty theme auto-reloading (now updates all instances without closing)
- Changed kitty terminal opacity from 85% to 75% for more transparency
- Fixed rofi theme validation error (removed circular variable reference)
- Fixed Ghostty theme configuration (removed invalid path format)
- Fixed matugen color templates for all applications
- Corrected Hyprland color format (rgb/rgba without # prefix)
- Fixed Rofi and Waybar CSS color format (single # not ##)
- Updated documentation for matugen theme system
- All applications now properly integrated with dynamic theming

**2025-12-06**
- Implemented rofi-based wallpaper picker with image thumbnails
- Added keyboard shortcut cheatsheet (Super+K)
- Changed app launcher to Super+Space
- Added application icons to Waybar window title
- Fixed wallpaper picker script syntax errors
- Removed macOS-only `teams` package

## Quick Reference

### System Management
```bash
# Check current host
hostname

# Rebuild system (replace hostname)
sudo nixos-rebuild switch --flake .#jboebook

# Test changes without making permanent
sudo nixos-rebuild test --flake .#jboebook

# Update flake inputs
nix flake update

# Validate configuration
nix flake check
```

### Important Keybindings
- `Super + Space` - Application launcher
- `Super + K` - Keybinding cheatsheet
- `Super + Shift + W` - Wallpaper picker
- `Super + Ctrl + W` - Random wallpaper
- `Super + Return` - Terminal (Ghostty)

## Documentation Structure

```
docs/
├── README.md              # This file - overview and index
├── system-overview.md     # Architecture and design philosophy
├── hosts.md              # Detailed host configurations
├── modules.md            # Complete module documentation
├── keybindings.md        # All keyboard shortcuts
├── troubleshooting.md    # Common issues and solutions
├── workflows.md          # How to perform common tasks
└── hyprland.md           # Hyprland-specific setup
```

## Philosophy

This configuration emphasizes:
- **Strict Modularity** - Everything is separated into focused modules
- **Multi-Host Support** - Shared configs with host-specific customization
- **Reproducibility** - Flakes ensure consistent builds
- **Documentation** - Everything is documented for easy reference

## Getting Help

1. Check the [Troubleshooting Guide](troubleshooting.md)
2. Review relevant module documentation in [Module Reference](modules.md)
3. Consult [Workflows](workflows.md) for common tasks
4. Check CLAUDE.md for AI assistant guidelines
