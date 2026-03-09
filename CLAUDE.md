# NixOS Configuration

## Overview

Flake-based NixOS configuration for a desktop machine (`jboedesk`). Uses nixpkgs unstable with a highly modular structure — each concern has its own module in `modules/`.

## Structure

```
flake.nix                  # Flake entry point, imports all modules
configuration.nix          # Minimal base config (flakes, unfree, stateVersion, hardware import)
hardware-configuration.nix # Auto-generated hardware config (do not edit)
modules/
  1password.nix            # 1Password CLI + GUI (polkit for jboe)
  audio.nix                # PipeWire audio (with PulseAudio/ALSA compat)
  boot.nix                 # systemd-boot, EFI, kernel packages
  desktop.nix              # GNOME desktop, GDM, printing
  ghostty.nix              # Ghostty terminal (config via activation script)
  keyboard.nix             # Keyboard/shortcuts (XKB, dconf keybindings, custom shortcuts)
  locale.nix               # Timezone (America/New_York) and locale (en_US.UTF-8)
  networking.nix           # Hostname (jboedesk), NetworkManager
  nvidia.nix               # NVIDIA GPU (open kernel module, modesetting)
  packages.nix             # User packages and programs (firefox, heroic, cli tools, etc.)
  steam.nix                # Steam, Gamescope, GameMode
  user.nix                 # User account definition (jboe)
  zsh.nix                  # Zsh shell config with aliases (cx, cc, nrs, oc, lg, etc.)
```

## Key Details

- **Host**: `jboedesk` (x86_64-linux, Intel CPU, NVIDIA GPU)
- **DE**: GNOME on Wayland (via GDM)
- **Shell**: Zsh
- **Terminal**: Ghostty (Catppuccin theme, JetBrains Mono Nerd Font)
- **User**: `jboe` (groups: networkmanager, wheel)

## Custom Keybindings (keyboard.nix)

- **Alt/Win swap**: `altwin:swap_alt_win` (XKB + dconf)
- **Super+Shift+S**: Screenshot UI
- **Super+W**: Close window
- **Ctrl+Shift+Space**: 1Password Quick Access (custom keybinding)
- GNOME overlay key disabled (to avoid Super key conflicts)

## External Config (not in this repo)

- `~/.config/environment.d/gemini.conf` — Gemini API key (kept out of git)

## Conventions

- Each concern gets its own module in `modules/` and is imported in `flake.nix`
- Modules use the standard NixOS module pattern: `{ pkgs, ... }: { ... }`
- User packages go in `modules/packages.nix` — only create a separate module if the package needs its own config options
- Drives: `/mnt/other`, `/mnt/projects`, `/mnt/steam` (defined in hardware-configuration.nix)
- `configuration.nix` should stay minimal (only base nix/nixpkgs settings and hardware import)
- `nixpkgs.config.allowUnfree = true` is enabled

## Important

- All recommendations and config changes must target **NixOS 25.11** with **flakes**
- Use options, syntax, and packages current as of **March 2026**
- Do not suggest deprecated options or pre-flake patterns

## Git Workflow

- **Remote**: `origin` → `git@github.com:JBoeCodes/holonix.git`
- **Branch**: `main`
- After every config change, add, commit, and push to `origin main`

## Rebuild

```
sudo nixos-rebuild switch --flake .
```
