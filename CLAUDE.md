# NixOS Configuration

## Overview

Flake-based NixOS configuration for a desktop machine (`jboedesk`). Uses nixpkgs unstable with a highly modular structure — each concern has its own module in `modules/`.

## Structure

```
flake.nix                  # Flake entry point, imports all modules
configuration.nix          # Minimal base config (flakes, unfree, stateVersion, hardware import)
hardware-configuration.nix # Auto-generated hardware config (do not edit)
modules/
  audio.nix                # PipeWire audio (with PulseAudio/ALSA compat)
  boot.nix                 # systemd-boot, EFI, kernel packages
  desktop.nix              # GNOME desktop, GDM, printing
  ghostty.nix              # Ghostty terminal (config via activation script)
  keyboard.nix             # Keyboard layout (US, Alt/Win swap via XKB + dconf)
  locale.nix               # Timezone (America/New_York) and locale (en_US.UTF-8)
  networking.nix           # Hostname (jboedesk), NetworkManager
  nvidia.nix               # NVIDIA GPU (open kernel module, modesetting)
  packages.nix             # User packages and programs (firefox, cli tools, etc.)
  user.nix                 # User account definition (jboe)
  zsh.nix                  # Zsh shell config with aliases (cx, cc)
```

## Key Details

- **Host**: `jboedesk` (x86_64-linux, Intel CPU, NVIDIA GPU)
- **DE**: GNOME on Wayland (via GDM)
- **Shell**: Zsh
- **Terminal**: Ghostty (Catppuccin theme, JetBrains Mono Nerd Font)
- **User**: `jboe` (groups: networkmanager, wheel)

## Conventions

- Each concern gets its own module in `modules/` and is imported in `flake.nix`
- Modules use the standard NixOS module pattern: `{ pkgs, ... }: { ... }`
- User packages go in `modules/packages.nix`
- `configuration.nix` should stay minimal (only base nix/nixpkgs settings and hardware import)
- `nixpkgs.config.allowUnfree = true` is enabled

## Rebuild

```
sudo nixos-rebuild switch --flake .
```
