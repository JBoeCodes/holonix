# Workflows

Common tasks and how to perform them in this NixOS configuration.

## Daily Operations

### Opening Applications

**Application Launcher**:
```
Super + Space → Type app name → Enter
```

**Common Apps**:
- Terminal: `Super + Return`
- Browser: `Super + B`
- File Manager: `Super + E`
- Keybinding help: `Super + K`

---

### Changing Wallpaper

**Visual Selection**:
```
Super + Shift + W
→ Navigate with arrows/type to search
→ Click or press Enter to apply
```

**Random Wallpaper**:
```
Super + Ctrl + W
```

**Add New Wallpapers**:
```bash
# Copy images to wallpaper directory
cp ~/Downloads/*.jpg ~/Pictures/wallpapers/

# Thumbnails auto-generate on next picker open
```

**Supported Formats**: jpg, jpeg, png, webp (case insensitive)

---

### Window Management

**Basic Operations**:
- Close window: `Super + Q` or `Super + W`
- Fullscreen: `Super + F`
- Float/Tile toggle: `Super + V`

**Moving Between Windows**:
- Arrow keys: `Super + ←↑↓→`
- Vim keys: `Super + H/J/K/L`

**Organizing Workspaces**:
1. `Super + [1-9]` - Switch to workspace
2. `Super + Shift + [1-9]` - Move window to workspace
3. Empty workspaces auto-close

**Scratchpad** (hidden workspace):
- Show/hide: `Super + S`
- Send window: `Super + Shift + S`
- Use for: music, notes, chat (quick access)

---

### Taking Screenshots

**Area Selection**:
```
Print → Drag to select area → Release
→ Automatically copied to clipboard
→ Paste with Ctrl+V
```

**Full Screen**:
```
Shift + Print
→ Copied to clipboard
```

---

## System Configuration

### Adding a New Package

**User Package** (most common):

1. Edit `home/modules/packages.nix`:
   ```nix
   home.packages = with pkgs; [
     # ... existing packages
     package-name
   ];
   ```

2. Rebuild:
   ```bash
   sudo nixos-rebuild switch --flake .#jboebook
   ```

**System Package** (services, system tools):

1. Edit `hosts/jboebook/packages.nix`:
   ```nix
   environment.systemPackages = with pkgs; [
     # ... existing packages
     package-name
   ];
   ```

2. Rebuild

**Find Package Names**:
```bash
# Search NixOS packages
nix search nixpkgs package-name

# Or use website
# https://search.nixos.org/packages
```

---

### Creating a New Module

**1. Choose Category**:
- `config/` - Users, fonts, locales
- `display/` - Desktop environments
- `hardware/` - Audio, graphics, bluetooth
- `network/` - Network, VPN, SMB
- `system/` - Boot, nix, services
- `tools/` - Application configs

**2. Create Module File**:
```bash
vim modules/category/feature-name.nix
```

Example:
```nix
{ config, pkgs, ... }:

{
  # Your configuration
  services.something.enable = true;

  environment.systemPackages = with pkgs; [
    related-package
  ];
}
```

**3. Import in modules/default.nix**:
```nix
imports = [
  # ... existing imports
  ./category/feature-name.nix
];
```

**4. Add to Git**:
```bash
git add modules/category/feature-name.nix
```

**5. Validate and Rebuild**:
```bash
nix flake check
sudo nixos-rebuild switch --flake .#jboebook
```

---

### Updating System Packages

**Update All Package Inputs**:
```bash
cd ~/nixos
nix flake update
```

**Update Specific Input**:
```bash
nix flake lock --update-input nixpkgs
```

**Apply Updates**:
```bash
sudo nixos-rebuild switch --flake .#jboebook
```

**Check What Would Update**:
```bash
nix flake update --dry-run
```

---

### Customizing Keybindings

**Edit Hyprland Keybindings**:

1. Open config:
   ```bash
   vim ~/nixos/home/modules/hypr/hyprland.nix
   ```

2. Find `bind = [` section

3. Add new binding:
   ```nix
   "$mod, T, exec, alacritty"  # Super+T opens Alacritty
   "$mod SHIFT, B, exec, brave"  # Super+Shift+B opens Brave
   ```

4. Test without rebuilding:
   ```bash
   hyprctl keyword bind SUPER,T,exec,alacritty
   ```

5. If works, rebuild to make permanent

**Modifier Keys**:
- `$mod` = Super (Windows key)
- `$mod SHIFT` = Super + Shift
- `$mod CTRL` = Super + Ctrl
- `$mod ALT` = Super + Alt

**Common Actions**:
- `exec, command` - Run program
- `killactive` - Close window
- `workspace, N` - Switch workspace
- `movetoworkspace, N` - Move window
- `togglefloating` - Float/tile toggle
- `fullscreen` - Fullscreen toggle

---

### Changing Waybar Configuration

**Edit Waybar**:
```bash
vim ~/nixos/home/modules/hypr/waybar.nix
```

**Common Customizations**:

**Add Module**:
```nix
# In settings.mainBar
modules-right = [ "pulseaudio" "network" "new-module" "clock" ];

# Define module
"new-module" = {
  format = "Icon {}";
  tooltip = true;
};
```

**Change Colors** (in `style` section):
```css
#module-name {
  color: #89b4fa;
  background: rgba(30, 30, 46, 0.85);
}
```

**Rebuild**:
```bash
sudo nixos-rebuild switch --flake .#jboebook
```

**Quick Restart** (without rebuild):
```bash
Super + Alt + W
# or
pkill waybar && waybar &
```

---

## Development Workflows

### Setting Up Development Environment

**Using nix-shell**:

Create `shell.nix`:
```nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    nodejs
    python3
    gcc
  ];
}
```

Enter environment:
```bash
nix-shell
```

**Using direnv** (automatic):

1. Install direnv:
   ```nix
   home.packages = [ pkgs.direnv ];
   ```

2. Create `.envrc`:
   ```bash
   use nix
   ```

3. Allow:
   ```bash
   direnv allow
   ```

---

### Git Workflow for Configuration

**Making Changes**:
```bash
# 1. Check current state
git status

# 2. Make changes to configuration
vim modules/something.nix

# 3. Add new files (IMPORTANT for flakes)
git add modules/something.nix

# 4. Validate
nix flake check

# 5. Test rebuild
sudo nixos-rebuild test --flake .#jboebook

# 6. If good, make permanent
sudo nixos-rebuild switch --flake .#jboebook

# 7. Commit changes
git add -u  # Updated files
git commit -m "Description of changes"

# 8. Push to GitHub
git push origin main
```

**Viewing History**:
```bash
# See what changed
git log --oneline

# See specific commit
git show <commit-hash>

# Compare versions
git diff HEAD~1 HEAD
```

**Reverting Changes**:
```bash
# Undo last commit (keep changes)
git reset HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1

# Revert to specific commit
git checkout <commit-hash> -- file.nix
```

---

## Maintenance

### Cleaning Up Old Generations

**View Generations**:
```bash
# System generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Home Manager generations
home-manager generations
```

**Remove Old Generations**:
```bash
# Delete everything older than 7 days
sudo nix-collect-garbage --delete-older-than 7d

# Delete all old generations
sudo nix-collect-garbage -d

# Also cleanup home-manager
nix-collect-garbage -d
```

**Optimize Store**:
```bash
# Remove duplicate files
nix-store --optimise
```

**Check Disk Usage**:
```bash
# Nix store size
du -sh /nix/store

# System profile size
du -sh /nix/var/nix/profiles/system*
```

---

### Backing Up Configuration

**What to Back Up**:
- Entire `~/nixos/` directory (already in git)
- Optional: `/etc/nixos/` if you added anything there

**Git Backup** (automatic):
```bash
# Already backing up by pushing to GitHub
git push origin main
```

**Manual Backup**:
```bash
# Create tarball
tar czf nixos-config-$(date +%Y%m%d).tar.gz ~/nixos/

# Copy to external drive
cp nixos-config-*.tar.gz /mnt/backup/
```

**What NOT to Back Up**:
- `result` symlinks (build outputs)
- `.direnv/` directories
- Hardware-specific `/etc/nixos/hardware-configuration.nix` (unique per machine)

---

### Restoring Configuration on New Machine

**1. Clone Repository**:
```bash
git clone https://github.com/yourusername/nixos-config.git ~/nixos
cd ~/nixos
```

**2. Generate Hardware Config**:
```bash
sudo nixos-generate-config --show-hardware-config > hosts/newhostname/hardware-configuration.nix
```

**3. Create Host Configuration**:
```bash
# Copy existing host as template
cp -r hosts/jboebook hosts/newhostname

# Edit configuration.nix
vim hosts/newhostname/configuration.nix
# Change hostname to "newhostname"
```

**4. Add to Flake**:
```bash
vim flake.nix
# Add newhostname to nixosConfigurations
```

**5. Build**:
```bash
sudo nixos-rebuild switch --flake .#newhostname
```

---

## Troubleshooting Workflows

### When Something Breaks

**1. Boot to Previous Generation**:
- Reboot
- Hold Space during boot
- Select previous generation
- Boot into working system

**2. Investigate**:
```bash
# Check what changed
git log --oneline
git diff HEAD~1 HEAD

# Check system logs
journalctl -b -p err
```

**3. Fix**:
```bash
# Revert changes
git revert HEAD

# Or manually fix config
vim problematic-file.nix

# Rebuild
sudo nixos-rebuild switch --flake .#jboebook
```

---

### Testing Risky Changes

**Use Test Mode**:
```bash
# Build and activate but don't set as boot default
sudo nixos-rebuild test --flake .#jboebook

# If it breaks, just reboot to previous generation
# If it works, make permanent:
sudo nixos-rebuild switch --flake .#jboebook
```

**Use Build-Only Mode**:
```bash
# Build without activating
nixos-rebuild build --flake .#jboebook

# Manually inspect result
ls -l result/
```

---

## Workspace Organization Tips

### Recommended Workspace Layout

- **Workspace 1**: Browser (Firefox/Brave)
- **Workspace 2**: Code editor (VSCode, Neovim)
- **Workspace 3**: Terminal (development)
- **Workspace 4**: Documentation, notes
- **Workspace 5**: Communication (if used)
- **Scratchpad**: Music (Spotify), calculator, quick notes

### Moving Windows Efficiently

**Send and Follow**:
```bash
# Send window to workspace 2 and follow
Super + Shift + 2
Super + 2
```

**Collect Windows**:
```bash
# Switch to workspace
Super + 3

# Open needed applications
Super + Space → "vscode"
Super + Return  # Terminal
```

---

## Shell Aliases

### Built-in Aliases (Zsh)

**NixOS Operations**:
- `nrs` - `nixos-rebuild switch`
- `nrt` - `nixos-rebuild test`
- `nrb` - `nixos-rebuild boot`
- `nfu` - `nix flake update`
- `nfc` - `nix flake check`
- `nixai` - `cd ~/nixos && claude`

**Modern CLI Tools**:
- `ls` → `eza -la --icons`
- `cat` → `bat`
- `find` → `fd`
- `cd` → `z` (zoxide, smart cd)
- `htop` → `btop`

**Using Aliases**:
```bash
# Instead of:
sudo nixos-rebuild switch --flake .#jboebook

# Use:
cd ~/nixos && sudo nrs --flake .#jboebook
```

---

## Quick Reference Commands

### System Information
```bash
hostname              # Current host
nixos-version        # NixOS version
nix --version        # Nix version
uname -r             # Kernel version
```

### Package Management
```bash
nix search nixpkgs NAME           # Search packages
nix-env -qaP NAME                 # Query available
nix-store -q --references STORE   # Package dependencies
```

### Service Management
```bash
systemctl status SERVICE          # Service status
systemctl restart SERVICE         # Restart service
systemctl --user status SERVICE   # User service
journalctl -u SERVICE            # Service logs
```

### Hyprland
```bash
hyprctl monitors                 # Monitor info
hyprctl clients                  # Window list
hyprctl workspaces              # Workspace info
hyprctl dispatch workspace 2    # Switch workspace
```

---

## See Also

- [Troubleshooting Guide](troubleshooting.md) - When things go wrong
- [Module Reference](modules.md) - All available modules
- [Keybindings](keybindings.md) - Keyboard shortcuts
- [System Overview](system-overview.md) - Architecture details
