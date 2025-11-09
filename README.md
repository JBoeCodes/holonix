# NixOS Gaming Desktop Configuration

A NixOS flake-based configuration for a gaming/desktop system with NVIDIA graphics and GNOME desktop environment.

## Quick Start

Apply configuration changes:
```bash
sudo nixos-rebuild switch --flake .#jboedesk
```

Test configuration without making it default:
```bash
sudo nixos-rebuild test --flake .#jboedesk
```

Update flake inputs:
```bash
nix flake update
```

Validate configuration:
```bash
nix flake check
```

## System Features

- **OS**: NixOS 25.05 (stable)
- **Desktop**: GNOME with GDM
- **Graphics**: NVIDIA proprietary drivers
- **Target**: Gaming and desktop use
- **Architecture**: Single-host flake configuration

## Structure

- `flake.nix` - Main flake definition with inputs and outputs
- `hosts/jboedesk/` - Host-specific configuration
  - `configuration.nix` - Main system configuration
  - `hardware-configuration.nix` - Hardware-specific settings
- `modules/` - Modular configuration files
- `home-manager/` - Home manager configurations
- `CLAUDE.md` - AI assistant guidance for this repository
