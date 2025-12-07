# Hyprland Configuration

Complete documentation for Hyprland setup in this configuration.

## Overview

Hyprland is a dynamic tiling Wayland compositor configured through Home Manager.

**Configuration Location**: `home/modules/hypr/hyprland.nix`

**Related Modules**:
- `waybar.nix` - Status bar
- `rofi.nix` - Application launcher
- `wallpaper-picker.nix` - Wallpaper management
- `keybind-cheatsheet.nix` - Keyboard reference

## Core Configuration

### Color Theming

**Dynamic Theme System**: This configuration uses [matugen](https://github.com/InioX/matugen) for automatic color generation from wallpaper.

**How It Works**:
1. Select wallpaper via theme-picker (Super+Shift+W)
2. Matugen extracts Material Design 3 color palette
3. Generates `~/.config/hypr/colors.conf` with border colors
4. Hyprland sources this file and reloads automatically

**Color Configuration Location**:
- **Template**: `home/modules/matugen.nix` (Hyprland section)
- **Generated File**: `~/.config/hypr/colors.conf`
- **Sourced In**: `home/modules/hypr/hyprland.nix` via `extraConfig`

**Manual Color Override**:
To use static colors instead of matugen, comment out the `source` line and add colors directly:
```nix
# extraConfig = ''
#   source = ~/.config/hypr/colors.conf
# '';

settings.general = {
  "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
  "col.inactive_border" = "rgba(595959aa)";
};
```

**Matugen Integration Benefits**:
- Cohesive colors across Hyprland, Waybar, Rofi, and Ghostty
- Automatic adaptation to wallpaper aesthetics
- Material Design 3 color harmony
- No manual color picking required

---

### Display Settings

**Monitor Configuration**:
```nix
monitor = ",preferred,auto,1.6"
```

- Uses preferred resolution
- Auto positioning
- 1.6x scale (for jboebook laptop display)
- Adjust scale for different displays (1.0 for 1080p, 1.5-2.0 for HiDPI)

---

### Layout

**Primary Layout**: Dwindle

```nix
general.layout = "dwindle"

dwindle = {
  pseudotile = true;
  preserve_split = true;
};
```

**Dwindle Characteristics**:
- Binary space partitioning
- Windows split recursively
- New windows use half of current window's space
- Preserves split direction across workspace switches

**Alternative**: Master layout (configured but not active)
```nix
master = {
  new_status = "master";
};
```

---

### Visual Settings

**Gaps**:
```nix
general = {
  gaps_in = 5;   # Gaps between windows
  gaps_out = 10; # Gaps from screen edges
};
```

**Borders**:
```nix
general = {
  border_size = 2;
  # Border colors sourced from matugen-generated colors.conf
  # See: ~/.config/hypr/colors.conf
};
```

- Border colors dynamically generated from wallpaper
- Active border: Gradient using primary/secondary colors from Material Design 3 palette
- Inactive border: Surface variant color with transparency
- 2px thickness
- Colors update automatically when wallpaper changes via theme-picker

**Static Color Examples** (if not using matugen):
```nix
"col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";  # Cyan to green
"col.inactive_border" = "rgba(595959aa)";  # Gray
```

**Rounding**:
```nix
decoration = {
  rounding = 10;
};
```

All windows have 10px rounded corners.

**Blur**:
```nix
decoration = {
  blur = {
    enabled = true;
    size = 3;
    passes = 1;
  };
};
```

- Subtle blur on transparent windows
- 3px blur radius
- Single pass (performance)

---

### Animations

**Enabled Animations**:
```nix
animations = {
  enabled = true;
  bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

  animation = [
    "windows, 1, 7, myBezier"
    "windowsOut, 1, 7, default, popin 80%"
    "border, 1, 10, default"
    "borderangle, 1, 8, default"
    "fade, 1, 7, default"
    "workspaces, 1, 6, default"
  ];
};
```

**Bezier Curve**: Custom easing (elastic-like)
- Control points: (0.05, 0.9, 0.1, 1.05)
- Slight overshoot effect

**Animation Breakdown**:
- **windows**: Opening/moving windows (7 frames, custom bezier)
- **windowsOut**: Closing windows (7 frames, pop-in to 80%)
- **border**: Border color changes (10 frames)
- **borderangle**: Gradient rotation (8 frames)
- **fade**: Opacity changes (7 frames)
- **workspaces**: Workspace switching (6 frames)

**Speed**: 1 (normal speed multiplier)

---

### Input Configuration

**Keyboard**:
```nix
input = {
  kb_layout = "us";
  follow_mouse = 1;
  sensitivity = 0;
};
```

- US QWERTY layout
- Focus follows mouse
- Default mouse sensitivity

**Touchpad** (laptops):
```nix
input.touchpad = {
  natural_scroll = true;
  disable_while_typing = true;
};
```

- Natural scrolling (like macOS/phones)
- Automatically disable during typing

---

## Autostart Programs

**Programs Started with Hyprland**:
```nix
exec-once = [
  "waybar"
  "dunst"
  "swww-daemon"
  "~/.local/bin/restore-wallpaper"
];
```

1. **Waybar** - Status bar (top panel)
2. **Dunst** - Notification daemon
3. **swww-daemon** - Wallpaper daemon
4. **restore-wallpaper** - Restore last wallpaper

---

## Window Rules

**Global Rules**:
```nix
windowrulev2 = [
  "suppressevent maximize, class:.*"
  "float, class:^(pavucontrol)$"
  "float, class:^(nm-connection-editor)$"
];
```

**Rule Explanations**:

1. **Suppress Maximize**: Prevents all windows from maximizing
   - Hyprland uses fullscreen instead
   - Maintains tiling workflow

2. **Float PulseAudio Control**:
   - `pavucontrol` always floating
   - Better for quick audio adjustments

3. **Float Network Manager**:
   - `nm-connection-editor` always floating
   - Quick network settings

**Adding Window Rules**:
```nix
# Float specific app
"float, class:^(app-name)$"

# Set size
"size 800 600, class:^(app-name)$"

# Set position (center)
"center, class:^(app-name)$"

# Pin to all workspaces
"pin, class:^(app-name)$"

# Opacity
"opacity 0.9, class:^(app-name)$"
```

**Finding Window Class**:
```bash
hyprctl clients
# Look for "class" field
```

---

## Keybindings

See [keybindings.md](keybindings.md) for complete reference.

### Keybinding Categories

1. **Program Launches** - Open applications
2. **Window Management** - Close, float, fullscreen
3. **Focus Movement** - Navigate between windows
4. **Workspace Switching** - Change workspaces
5. **Move Windows** - Send windows to workspaces
6. **Wallpaper** - Change backgrounds
7. **System** - Screenshots, restart services
8. **Mouse** - Window manipulation

### Modifier Key

```nix
"$mod" = "SUPER";
```

All bindings use Super (Windows key) as modifier.

---

## Workspace Configuration

**Number of Workspaces**: 10 (1-9, 0)

**Workspace Behavior**:
- Created on-demand
- Automatically destroyed when empty
- Persistent until empty
- Independent per monitor

**Special Workspace** (Scratchpad):
```nix
# Toggle visibility
"$mod, S, togglespecialworkspace, magic"

# Send window to scratchpad
"$mod SHIFT, S, movetoworkspace, special:magic"
```

**Scratchpad Name**: "magic"
- Hidden workspace
- Quick show/hide
- Persists across workspace switches
- Perfect for: music, notes, chat

---

## Hyprland Ecosystem Settings

```nix
ecosystem = {
  no_update_news = true;
};
```

**Purpose**: Disable ecosystem update notifications

These notifications can be intrusive. Disabled for cleaner experience.

---

## Misc Settings

```nix
misc = {
  force_default_wallpaper = 0;
  disable_hyprland_logo = true;
};
```

- **force_default_wallpaper**: Don't use default wallpaper
- **disable_hyprland_logo**: No Hyprland logo on empty workspaces

Clean, minimal empty workspaces.

---

## Integration with Other Components

### Waybar Integration

Waybar reads Hyprland state through IPC:

**Waybar Modules Using Hyprland**:
- `hyprland/workspaces` - Workspace indicator
- `hyprland/window` - Active window title + icon
- `hyprland/submap` - Submap indicator (if used)

**Communication**: Unix socket at `/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket.sock`

---

### Rofi Integration

**Application Launcher**:
```nix
"$mod, Space, exec, rofi -show drun"
```

Rofi uses Wayland layer-shell for proper overlay.

**Custom Rofi Scripts**:
- Wallpaper picker (Super+Shift+W)
- Keybinding cheatsheet (Super+K)

---

### Screenshot Integration

**Tools Used**:
- `grim` - Screenshot capture
- `slurp` - Area selection
- `wl-clipboard` - Clipboard management

**Bindings**:
```nix
", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
"SHIFT, Print, exec, grim - | wl-copy"
```

Both copy to Wayland clipboard automatically.

---

### Wallpaper Integration

**Wallpaper Backend**: `swww` (Smooth Wayland Window Switcher)

**Features**:
- Smooth transitions
- Low resource usage
- Multiple transition types
- Per-monitor wallpapers

**Scripts**:
1. `wallpaper-picker` - Visual selection
2. `random-wallpaper` - Random from directory
3. `restore-wallpaper` - On startup

**Transition Settings** (in wallpaper scripts):
```bash
swww img "$wallpaper" \
  --transition-type wipe \
  --transition-angle 30 \
  --transition-duration 2 \
  --transition-fps 60
```

---

## Gestures

```nix
gestures = {
};
```

Currently empty but available for:
- Swipe gestures
- Pinch gestures
- Workspace switching gestures

**Example Usage**:
```nix
gestures = {
  workspace_swipe = true;
  workspace_swipe_fingers = 3;
};
```

---

## Submap Configuration

Submaps allow modal keybindings (like vim modes).

**Not currently configured**, but available for:
- Resize mode
- Window gap adjustment mode
- Custom mode groups

**Example Submap**:
```nix
bind = [
  # Enter resize mode
  "$mod, R, submap, resize"
];

# Resize mode bindings
submap = resize {
  bind = [
    ", H, resizeactive, -20 0"
    ", L, resizeactive, 20 0"
    ", escape, submap, reset"
  ];
}
```

---

## Performance Tuning

### Current Settings

**Allow Tearing**: Disabled
```nix
general.allow_tearing = false;
```

Better compatibility, slightly higher latency.

**VRR (Variable Refresh Rate)**: Not configured

**Could Enable**:
```nix
misc = {
  vrr = 1;  # Adaptive sync
};
```

### Optimization Tips

**For Better Performance**:
```nix
# Reduce blur
decoration.blur.passes = 1;  # Already minimal

# Reduce animations
animations.enabled = false;  # Or reduce speed

# Disable shadows
decoration.shadow = {
  enabled = false;
};
```

**For Better Visuals**:
```nix
# Increase blur
decoration.blur.passes = 3;

# Drop shadow
decoration.shadow = {
  enabled = true;
  range = 4;
  render_power = 3;
};
```

---

## Debugging

### View Current Configuration

```bash
# Full config dump
hyprctl getoption all

# Specific option
hyprctl getoption general:border_size

# Active window info
hyprctl activewindow

# All windows
hyprctl clients

# Monitor info
hyprctl monitors
```

---

### Testing Changes Without Rebuild

```bash
# Test single option
hyprctl keyword general:gaps_in 10

# Test keybinding
hyprctl keyword bind SUPER,T,exec,alacritty

# Reload config
hyprctl reload
```

**Note**: Changes are temporary. To persist, edit `hyprland.nix` and rebuild.

---

### Logging

**View Hyprland Logs**:
```bash
# User service logs
journalctl --user -u hyprland

# Follow live
journalctl --user -u hyprland -f

# Errors only
journalctl --user -u hyprland -p err
```

**Hyprland Debug Info**:
```bash
# Version and build info
hyprctl version

# System info
hyprctl systeminfo
```

---

## Customization Examples

### Change Border Colors

```nix
general = {
  # Solid color
  "col.active_border" = "rgba(89b4faff)";

  # Two-color gradient
  "col.active_border" = "rgba(f38ba8ff) rgba(fab387ff) 45deg";

  # Three-color gradient
  "col.active_border" = "rgba(f38ba8ff) rgba(fab387ff) rgba(f9e2afff) 45deg";
};
```

**Color Format**: `rgba(RRGGBBaa)`
- RR, GG, BB: Hex color values
- aa: Alpha (opacity)
- Gradient angle after colors

---

### Add New Keybinding

```nix
bind = [
  # ... existing bindings

  # Open Spotify
  "$mod, M, exec, spotify"

  # Open calculator
  "$mod, C, exec, gnome-calculator"

  # Custom script
  "$mod SHIFT, R, exec, ~/.local/bin/my-script"
];
```

---

### Per-Monitor Configuration

```nix
# Monitor 1: Main display
monitor = "DP-1,2560x1440@144,0x0,1"

# Monitor 2: Secondary
monitor = "HDMI-A-1,1920x1080@60,2560x0,1"

# Laptop internal
monitor = "eDP-1,1920x1080@60,0x0,1.5"
```

**Format**: `name,resolution@rate,position,scale`

**Find Monitor Names**:
```bash
hyprctl monitors
```

---

### Window-Specific Rules

```nix
windowrulev2 = [
  # Firefox picture-in-picture
  "float, title:^(Picture-in-Picture)$"
  "pin, title:^(Picture-in-Picture)$"
  "size 640 360, title:^(Picture-in-Picture)$"

  # Steam overlay
  "float, class:^(steam)$,title:^(Friends List)$"
  "size 300 800, class:^(steam)$,title:^(Friends List)$"

  # Transparency
  "opacity 0.9, class:^(Alacritty)$"
];
```

---

## Advanced Features

### Layer Rules

Control layer-shell surfaces (like waybar):

```nix
layerrule = [
  "blur, waybar"
  "ignorezero, waybar"
];
```

---

### Dispatchers

Execute actions programmatically:

```bash
# Move window to workspace
hyprctl dispatch movetoworkspace 2

# Toggle floating
hyprctl dispatch togglefloating

# Execute command
hyprctl dispatch exec firefox

# Focus monitor
hyprctl dispatch focusmonitor 1
```

---

### IPC Integration

**Socket Location**: `/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock`

**Listen to Events**:
```bash
socat -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock
```

**Events Available**:
- workspace
- activewindow
- fullscreen
- monitoradded
- createworkspace
- And more...

**Use Case**: Custom scripts reacting to Hyprland events

---

## Common Issues

### Windows Not Tiling

**Check**:
1. Window might have size constraints
2. Window might request floating
3. Check window rules

**Force Tile**:
```bash
hyprctl dispatch togglefloating
```

---

### Blur/Transparency Not Working

**Ensure**:
1. Window is actually transparent (check app config)
2. Blur enabled in decoration
3. Opacity set if needed

**Test**:
```bash
hyprctl keyword decoration:blur:enabled true
```

---

### Poor Performance

**Try**:
1. Reduce animation speed
2. Disable blur
3. Reduce blur passes
4. Disable shadows
5. Check `btop` for resource usage

---

## Resources

**Official Documentation**:
- Hyprland Wiki: https://wiki.hyprland.org
- GitHub: https://github.com/hyprwm/Hyprland

**Configuration**:
- Example Configs: https://wiki.hyprland.org/Configuring/Example-configurations/
- Window Rules: https://wiki.hyprland.org/Configuring/Window-Rules/
- Dispatchers: https://wiki.hyprland.org/Configuring/Dispatchers/

**Community**:
- Discord: https://discord.gg/hQ9XvMUjjr
- Reddit: r/hyprland

**This Setup**:
- [Keybindings](keybindings.md)
- [Troubleshooting](troubleshooting.md)
- [Workflows](workflows.md)
