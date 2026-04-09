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
  kitty.nix                # Kitty terminal (KoolDots themed, NixOS overrides via activation script)
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
- **Terminal**: Kitty (wallust dynamic theming via KoolDots, JetBrains Mono Nerd Font)
- **User**: `jboe` (groups: networkmanager, wheel)

## Custom Keybindings (keyboard.nix)

- **Super+Shift+S**: Screenshot UI
- **Super+W**: Close window
- **Ctrl+Shift+Space**: 1Password Quick Access (custom keybinding)
- GNOME overlay key disabled (to avoid Super key conflicts)

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

## Hyprland Config Notes

Hyprland moves fast and has breaking syntax changes between versions. Before editing `modules/hyprland.nix`:

1. **Check the running version first**: `hyprctl version`
2. **Check for existing errors**: `hyprctl configerrors`
3. **Do not rely on training data for Hyprland syntax** — it is likely outdated. Use `WebSearch` to verify current syntax against the wiki (wiki.hyprland.org) before writing.

### Current syntax (0.53+, as of 0.54.2)

Window rules use named block syntax:

```
windowrule {
    name = unique-name       # required, must be first
    float = on               # boolean flags need = on
    center = on
    stay_focused = on
    suppress_event = maximize
    match:class = ^(regex)$  # selector
    match:title = ^(regex)$  # selector
}
```

- `name` is **required** as the first field in every block
- All boolean rules use `= on` (bare keywords are invalid)
- `windowrulev2` and the old inline `windowrule = rule, class:pattern` syntax are both deprecated and broken

## TODO — Hyprland Ultimate Desktop + Hardening

Full plan: `~/.claude/plans/splendid-toasting-cocoa.md`

### Security Hardening
- [x] Create `modules/hardening.nix` (kernel sysctls + Firejail for Discord/Telegram/VLC/qBittorrent + sudo + firewall logging)
- [x] Import `modules/hardening.nix` in `flake.nix`

### Visual Overhaul
- [x] Enhanced blur (`ignore_opacity=true`, `noise`, `popups`), transparency (0.92/0.85), rounding (12), shadows
- [x] Animated gradient borders (`borderangle` loop, mauve→blue→green)
- [x] Upgraded animations (wind/winIn/winOut beziers, slidevert workspaces)
- [x] Kitty transparency (`background-opacity = 0.85`)
- [x] Catppuccin GTK theme + cursors + Papirus icons

### Component Swaps
- [x] Replace Wofi → Rofi-Wayland (Catppuccin .rasi theme, update all binds)
- [x] Replace Hyprpaper → swww (animated transitions, keep waypaper as GUI)
- [x] Replace Mako → SwayNC (notification center with history, Catppuccin CSS)

### Workflow
- [x] Gaming: VRR, tearing, Steam window rules (no transparency/blur), mangohud
- [x] Dev scratchpads: dropdown terminal (`$mod+grave`), lazygit (`$mod+G`), btop (`$mod+B`)
- [x] PiP window rules (float, pin, top-right, keepaspectratio)
- [x] Browser idle inhibit for fullscreen video
- [x] Extra screenshot/recording binds + wf-recorder
- [x] Enhanced Waybar (SwayNC module, hover effects, color-coded states)
- [x] Enhanced Hyprlock (profile image, uptime, decorative accents)

### New Packages
- [x] Add: rofi-wayland, swww, swaynotificationcenter, wf-recorder, mangohud, catppuccin-gtk, catppuccin-cursors, catppuccin-papirus-folders, yazi
- [x] Remove: wofi, hyprpaper, mako

Note: physical security hardening (Secure Boot, LUKS, encrypted swap, TPM) is unnecessary — single-user desktop, no physical access threat

## Rebuild

**Do NOT run `sudo nixos-rebuild` or any `nixos-*` commands.** The user will rebuild manually. Your job ends at commit and push.

Rebuild command (for the user):
```
sudo nixos-rebuild switch --flake .
```
