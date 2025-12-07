# Troubleshooting Guide

Common issues encountered and their solutions.

## Build/Configuration Issues

### Package Not Available on Platform

**Symptom**:
```
error: Package 'teams-...' is not available on the requested hostPlatform:
  hostPlatform.system = "x86_64-linux"
  package.meta.platforms = [ "x86_64-darwin" "aarch64-darwin" ]
```

**Cause**: Package only supports macOS, not Linux

**Solution**:
1. Find the package reference (usually in `home/modules/packages.nix`)
2. Remove or make conditional:
   ```nix
   # Remove entirely:
   # teams

   # Or make conditional:
   (lib.mkIf pkgs.stdenv.isDarwin pkgs.teams)
   ```

**Example from Session** (2025-12-06):
- Removed `teams` package from `home/modules/packages.nix:6`
- Teams is macOS-only, use `teams-for-linux` alternative if needed

---

### Flake Path Does Not Exist

**Symptom**:
```
error: path '/home/jboe/nixos/modules/new-module.nix' does not exist
```

**Cause**: New files not tracked by git. Flakes only include tracked files.

**Solution**:
```bash
# ALWAYS add new files to git before flake check
git add modules/new-module.nix
nix flake check
```

**Prevention**: Make this a habit - `git add` immediately after creating new files.

---

### Bash Script Syntax Errors

**Symptom**:
```bash
line 19: syntax error near unexpected token `2'
for wallpaper in "$DIR"/*.{jpg,png} 2>/dev/null; do
```

**Cause**: Cannot redirect stderr (`2>/dev/null`) in for loop variable declaration

**Solution**:
Use `shopt -s nullglob` instead:
```bash
# Wrong:
for file in *.jpg 2>/dev/null; do

# Correct:
shopt -s nullglob
for file in *.jpg; do
```

**Example from Session** (2025-12-06):
- Fixed wallpaper-picker script
- Replaced invalid stderr redirects with nullglob
- File: `home/modules/hypr/wallpaper-picker.nix:24-34`

---

## Display/Window Manager Issues

### Rofi Menu Extends Off Screen

**Symptom**: Rofi window taller than screen, items cut off top/bottom

**Cause**:
- Too many lines visible
- Icon/element size too large
- No height constraint

**Solution**:
```nix
window {
  height: 65%;  # Constrain to screen percentage
  # or
  height: 800px;  # Fixed pixel height
}

listview {
  lines: 4;  # Reduce visible items
  fixed-height: true;  # Prevent overflow
}

element-icon {
  size: 120px;  # Reduce from 180px
}
```

**Example from Session** (2025-12-06):
- Wallpaper picker was extending off screen
- Reduced from 6 lines to 4
- Icon size from 180px to 120px
- Added window height: 65%

---

### Waybar Not Showing Application Icons

**Symptom**: Window titles show but no application icons

**Cause**: `icon` option not enabled in hyprland/window module

**Solution**:
Add to waybar configuration:
```nix
"hyprland/window" = {
  format = "{}";
  icon = true;
  icon-size = 20;  # Adjust size as needed
};
```

**Example from Session** (2025-12-06):
- Added `icon = true` to waybar config
- Set icon-size to 20px for proper fit
- File: `home/modules/hypr/waybar.nix:27-29`

---

### Rofi Not Showing Image Thumbnails

**Symptom**: Rofi shows text only, no image previews

**Cause**: Not using rofi's native thumbnail format

**Solution**:
Use `\0icon\x1f` format for rofi entries:
```bash
# Format: "display_name\0icon\x1f/path/to/image.jpg\n"
echo -en "wallpaper1\0icon\x1f/path/to/thumb.jpg\n"
```

**Research Source**:
- [Rofi Discussion #2001](https://github.com/davatorium/rofi/discussions/2001)
- Native rofi feature, no plugins needed

**Example from Session** (2025-12-06):
- Implemented in wallpaper-picker script
- Shows 120px thumbnails next to names
- File: `home/modules/hypr/wallpaper-picker.nix:65`

---

### Matugen Color Format Errors

**Symptom**: Errors when starting applications after theme generation:
- Ghostty: `theme "~/.config/ghostty/theme" cannot include path separators`
- Hyprland: `Error parsing gradient rgba(: failed to parse rgba( as a color`
- Rofi: Parse error at line 7

**Cause**: Incorrect color variable usage in matugen templates

**Root Issues**:
1. **Ghostty theme path**: Cannot use `~` or path separators in theme option
2. **Hyprland colors**: Template used `hex` instead of `hex_stripped`, causing `rgba(#RRGGBB)` instead of `rgba(RRGGBB)`
3. **Rofi/Waybar CSS**: Template used `hex` instead of `hex_stripped`, causing `##` instead of `#`

**Solutions**:

**1. Ghostty Theme Reference** (`home/modules/ghostty.nix`):
```nix
# Wrong:
theme = dark:~/.config/ghostty/theme,light:~/.config/ghostty/theme

# Correct:
theme = theme  # Just the filename, Ghostty looks in ~/.config/ghostty/
```

**2. Hyprland Color Format** (`home/modules/matugen.nix`):
```nix
# Template should use hex_stripped for Hyprland rgba()
col.active_border = rgb({{colors.primary.default.hex_stripped}})
col.inactive_border = rgba({{colors.surface_variant.default.hex_stripped}}aa)

# NOT hex (which includes #):
# col.active_border = rgba(#RRGGBB)  # WRONG - Hyprland doesn't accept #
```

**3. CSS/Rasi Color Format** (`home/modules/matugen.nix`):
```nix
# Template needs manual # prefix with hex_stripped
fg: #{{colors.on_surface.default.hex_stripped}};

# NOT just hex (causes ##):
# fg: #{{colors.on_surface.default.hex}};  # Results in ##RRGGBB
```

**Rule of Thumb**:
- **Always use `hex_stripped`** in matugen templates
- **Add `#` manually** when needed (CSS, Rasi)
- **No `#` prefix** for Hyprland rgb()/rgba()
- **Use RGB decimal** for rgba() with alpha: `rgba({{colors.xxx.red}}, {{colors.xxx.green}}, {{colors.xxx.blue}}, 0.95)`

**Color Variable Reference**:
```
{{colors.primary.default.hex}}          # Includes # → #RRGGBB
{{colors.primary.default.hex_stripped}} # No # → RRGGBB
{{colors.primary.default.red}}          # Decimal → 0-255
{{colors.primary.default.green}}        # Decimal → 0-255
{{colors.primary.default.blue}}         # Decimal → 0-255
```

**Validation**:
After changing templates, regenerate colors:
```bash
# Run theme-picker to regenerate all color files
# Super+Shift+W, or:
~/.local/bin/theme-picker

# Check generated files for correct format
cat ~/.config/hypr/colors.conf     # Should see: rgb(RRGGBB) not rgba(#RRGGBB)
cat ~/.config/rofi/colors.rasi     # Should see: #RRGGBB not ##RRGGBB
cat ~/.config/waybar/colors.css    # Should see: #RRGGBB not ##RRGGBB
cat ~/.config/ghostty/theme        # Should see: RRGGBB not #RRGGBB
```

**Example from Session** (2025-12-07):
- Fixed all matugen templates to use `hex_stripped`
- Updated Ghostty to use simple theme filename
- Manually corrected generated color files
- Files: `home/modules/matugen.nix`, `home/modules/ghostty.nix`

---

### Rofi Theme Validation Failed

**Symptom**: Rofi shows error when launching:
```
Validating the theme failed: the variable 'urgent' in `element normal urgent { text-color: var(urgent);}` failed to resolve.
Found more then 20 redirects for property. Stopping.
```

**Cause**: Circular variable reference in rofi theme

**Explanation**:
- Theme imports `colors.rasi` which defines `urgent: #RRGGBB`
- Theme then redefines `urgent: @urgent` creating circular reference
- Rofi follows redirect chain and hits 20-redirect limit

**Solution**:
Remove the circular variable redefinition in `home/modules/hypr/rofi.nix`:

```nix
* {
  /* Use matugen colors - imported from colors.rasi */
  bg0: @bg;
  bg1: @bg-alt;
  bg2: @selected;
  fg0: @fg;
  fg1: @fg;
  accent: @fg-alt;
  # Remove this line: urgent: @urgent;  # CIRCULAR REFERENCE

  background-color: transparent;
  text-color: @fg0;
}
```

**Rule**: Don't redefine variables that are already imported - just use them directly.

**Fixed**: 2025-12-07

---

### YAD Shows Blank White Window

**Symptom**: YAD icon browser opens but shows nothing

**Cause**: YAD is GTK-based, may have compatibility issues with Wayland/Hyprland

**Solution**: Use rofi instead with native thumbnail support
- Rofi integrates better with Hyprland
- Native Wayland support
- Consistent theming with rest of system

---

## System Management Issues

### Wrong Host Being Built

**Symptom**: Changes for jboebook being applied to jboedesk

**Cause**: Using wrong flake reference in rebuild command

**Solution**:
```bash
# Always check current host first
hostname

# Use correct host in rebuild
sudo nixos-rebuild switch --flake .#jboebook
# NOT .#jboedesk
```

**Prevention**:
- Check `hostname` before every rebuild
- Create shell aliases with correct host
- Add host to shell prompt

---

### Version Mismatch Errors

**Symptom**: Configuration option not recognized, build fails

**Cause**: Using option from newer/older NixOS version

**Solution**:
1. Check current version: `nixos-version`
2. Search for option in version-specific docs
3. Use WebSearch to verify: "NixOS 25.11 [option name]"
4. Update or use alternative option

**Prevention**:
- Always verify options against current version
- Check package/service version before configuring
- Document version requirements

---

## Application Issues

### Wallpaper Picker Not Opening

**Symptom**: Super+Shift+W does nothing

**Cause**: Script has syntax errors or isn't executable

**Solution**:
```bash
# Test script manually
~/.local/bin/wallpaper-picker

# Check for errors
# Fix syntax errors in source
# Rebuild to regenerate script

sudo nixos-rebuild switch --flake .#jboebook
```

**Historical Issues**:
- Bash syntax errors (2>/dev/null in wrong place)
- Missing nullglob setting
- Fixed 2025-12-06

---

### Keybinding Not Working

**Symptom**: Pressing key combo does nothing

**Possible Causes**:
1. **Application intercepts**: App using same shortcut
2. **Syntax error**: Typo in hyprland.nix
3. **Not rebuilt**: Changes not applied
4. **Conflicting bind**: Another binding takes priority

**Solutions**:
```bash
# Test binding manually
hyprctl keyword bind SUPER,K,exec,some-command

# Check current bindings
hyprctl binds

# View Hyprland config
hyprctl activewindow

# Check logs
journalctl --user -u hyprland -n 50
```

---

### Missing Application Icons

**Symptom**: Some apps show generic icon instead of their icon

**Cause**: Icon theme not installed or app doesn't provide icon

**Solution**:
```nix
# Install icon theme
environment.systemPackages = with pkgs; [
  papirus-icon-theme
  # or
  adwaita-icon-theme
];

# Set icon theme (GNOME)
programs.gnome.enable = true;
```

---

## Network Issues

### Cannot Access SMB Shares

**Symptom**: Windows shares not accessible in file manager

**Cause**: Missing SMB support packages

**Solution**: Ensure `modules/network/smb.nix` is imported:
```nix
services.gvfs.enable = true;
environment.systemPackages = [ pkgs.cifs-utils ];
```

**Access Format**: `smb://server/share` in file manager

---

### WiFi Not Showing Networks

**Symptom**: No WiFi networks visible

**Solutions**:
```bash
# Check NetworkManager status
systemctl status NetworkManager

# Restart NetworkManager
sudo systemctl restart NetworkManager

# Check WiFi device
nmcli device

# Scan for networks
nmcli device wifi rescan
nmcli device wifi list
```

---

## Hardware Issues

### NVIDIA Graphics Not Working

**Symptom**: Poor performance, using integrated graphics

**Checks**:
```bash
# Verify NVIDIA driver loaded
lsmod | grep nvidia

# Check which GPU is active
glxinfo | grep "OpenGL renderer"

# NVIDIA settings
nvidia-settings
```

**Solution**:
Ensure `modules/hardware/nvidia.nix` is enabled and hostname matches:
```nix
programs.nvidia.enable = lib.mkIf (config.networking.hostName == "jboedesk") true;
```

**Only applies to**: jboedesk

---

### No Audio Output

**Symptom**: Sound not working, no output devices

**Solutions**:
```bash
# Check PipeWire status
systemctl --user status pipewire pipewire-pulse

# Restart PipeWire
systemctl --user restart pipewire pipewire-pulse

# Check outputs
pactl list sinks

# Set default sink
pactl set-default-sink [sink-name]
```

**GUI Tools**:
- `pavucontrol` - Volume control and device selection
- Click Waybar audio icon to open

---

### Battery Not Showing (Laptop)

**Symptom**: Waybar shows no battery module

**Causes**:
1. Not a laptop (desktop)
2. Battery module misconfigured
3. ACPI not working

**Solution**:
```bash
# Check battery presence
ls /sys/class/power_supply/

# Check ACPI
acpi -V

# Install if missing (laptops)
environment.systemPackages = [ pkgs.acpi ];
```

---

## Git/Flake Issues

### Dirty Git Tree Warning

**Symptom**:
```
warning: Git tree '/home/jboe/nixos' is dirty
```

**Cause**: Uncommitted changes in repository

**Impact**: Warning only, doesn't prevent builds

**Solutions**:
```bash
# View changes
git status

# Commit changes
git add .
git commit -m "Description"

# Or ignore (builds still work)
```

**Note**: This is just a warning, flake operations still succeed

---

### Flake Lock Conflicts

**Symptom**: Merge conflicts in `flake.lock`

**Solution**:
```bash
# Take one version
git checkout --theirs flake.lock
# or
git checkout --ours flake.lock

# Then update
nix flake update
```

---

## Performance Issues

### Slow Rebuild Times

**Causes**:
- Building large packages from source
- Many packages need updating
- Slow disk I/O

**Solutions**:
```bash
# Use binary cache
nix.settings.substituters = [
  "https://cache.nixos.org"
];

# Parallel builds
nix.settings.max-jobs = 4;
nix.settings.cores = 4;

# Cleanup old generations
sudo nix-collect-garbage -d
```

---

### High Memory Usage

**Symptom**: System slowing down, high memory in `btop`

**Causes**:
- Many applications open
- Electron apps (VSCode, Spotify, etc.)
- Memory leak in application

**Solutions**:
```bash
# Check memory usage
btop
# or
free -h

# Close unused applications
# Restart memory-hungry apps
# Add more swap if needed
```

---

## Emergency Recovery

### System Won't Boot

**Solutions**:

1. **Use previous generation**:
   - Hold Space during boot
   - Select previous generation from systemd-boot menu

2. **Boot from USB**:
   - Boot NixOS installer
   - Mount existing system
   - Fix configuration
   - Rebuild

3. **Chroot repair**:
   ```bash
   # Mount system
   sudo mount /dev/sdXY /mnt
   sudo nixos-enter --root /mnt

   # Fix configuration
   # Rebuild
   nixos-rebuild switch
   ```

---

### Hyprland Won't Start

**Solutions**:

1. **Use GNOME instead**:
   - Select GNOME from GDM login screen
   - Fix Hyprland config from GNOME

2. **Check logs**:
   ```bash
   journalctl --user -u hyprland
   ```

3. **Reset Hyprland config**:
   ```bash
   # Temporarily rename config
   mv ~/.config/hypr/hyprland.conf{,.bak}

   # Let home-manager regenerate
   sudo nixos-rebuild switch --flake .#hostname
   ```

---

## Getting More Help

### Check Logs

**System logs**:
```bash
journalctl -b           # This boot
journalctl -p err       # Errors only
journalctl -u service   # Specific service
```

**User services**:
```bash
journalctl --user -u pipewire
systemctl --user status hyprland
```

### Validate Configuration

```bash
# Before rebuilding
nix flake check

# Build without activating
nixos-rebuild build --flake .#hostname

# Test without making default
nixos-rebuild test --flake .#hostname
```

### Community Resources

- NixOS Manual: `man configuration.nix`
- NixOS Options: https://search.nixos.org/options
- Home Manager Options: https://nix-community.github.io/home-manager/options.xhtml
- Hyprland Wiki: https://wiki.hyprland.org
- This documentation: `~/nixos/docs/`

---

## Prevention Checklist

Before making changes:

- [ ] Check current hostname: `hostname`
- [ ] Verify NixOS version: `nixos-version`
- [ ] Check package/service version if configuring
- [ ] Read existing config to understand current state
- [ ] Create new modules rather than editing configuration.nix
- [ ] `git add` new files immediately
- [ ] Validate with `nix flake check`
- [ ] Test with `nixos-rebuild test` before `switch`
- [ ] Document significant changes

After changes:

- [ ] Verify expected behavior
- [ ] Check for warnings/errors
- [ ] Test affected features
- [ ] Commit to git with descriptive message
- [ ] Update documentation if needed
