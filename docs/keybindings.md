# Keybindings Reference

Complete keyboard shortcuts for Hyprland configuration.

## Modifier Key

`$mod` = **Super** (Windows key)

## Quick Reference

| Shortcut | Action |
|----------|--------|
| Super + Space | Application launcher |
| Super + K | Keybinding cheatsheet |
| Super + Return | Terminal (Ghostty) |
| Super + Q/W | Close window |
| Super + Shift + W | Wallpaper picker |

## Program Launches

| Shortcut | Program | Description |
|----------|---------|-------------|
| Super + Return | ghostty | Launch terminal |
| Super + Space | rofi | Application launcher |
| Super + B | firefox | Launch Firefox browser |
| Super + E | nautilus | Launch file manager |
| Super + K | keybind-cheatsheet | Show this cheatsheet |

**Recent Changes**:
- Changed launcher from Super+D to Super+Space
- Added Super+K for cheatsheet

---

## Window Management

| Shortcut | Action | Description |
|----------|--------|-------------|
| Super + Q | killactive | Close focused window |
| Super + W | killactive | Close focused window (alternative) |
| Super + M | exit | Exit Hyprland session |
| Super + V | togglefloating | Toggle floating mode |
| Super + F | fullscreen | Toggle fullscreen |
| Super + P | pseudo | Toggle pseudotile |
| Super + J | togglesplit | Toggle split direction |

**Notes**:
- Both Q and W close windows (common in browsers and terminals)
- Floating windows can be moved and resized freely
- Pseudotile maintains aspect ratio while tiled
- Fullscreen hides bars and maximizes window

---

## Focus Movement

Move focus between windows in the workspace.

### Arrow Keys

| Shortcut | Direction |
|----------|-----------|
| Super + Left | Focus left |
| Super + Right | Focus right |
| Super + Up | Focus up |
| Super + Down | Focus down |

### Vim Keys

| Shortcut | Direction |
|----------|-----------|
| Super + H | Focus left |
| Super + L | Focus right |
| Super + K | Focus up |
| Super + J | Focus down |

**Notes**:
- Both arrow keys and vim keys work
- Focus wraps around to opposite side
- Works in all layouts (dwindle, master)

---

## Workspace Switching

Navigate between workspaces 1-10.

| Shortcut | Workspace |
|----------|-----------|
| Super + 1 | Workspace 1 |
| Super + 2 | Workspace 2 |
| Super + 3 | Workspace 3 |
| Super + 4 | Workspace 4 |
| Super + 5 | Workspace 5 |
| Super + 6 | Workspace 6 |
| Super + 7 | Workspace 7 |
| Super + 8 | Workspace 8 |
| Super + 9 | Workspace 9 |
| Super + 0 | Workspace 10 |

### Special Workspaces

| Shortcut | Action | Description |
|----------|--------|-------------|
| Super + S | togglespecialworkspace | Show/hide scratchpad |
| Super + Mouse Wheel Up | workspace e+1 | Next workspace |
| Super + Mouse Wheel Down | workspace e-1 | Previous workspace |

**Notes**:
- Workspaces are created on-demand
- Empty workspaces are automatically destroyed
- Scratchpad (special:magic) is a hidden workspace for quick access
- Mouse wheel requires holding Super

---

## Move Windows to Workspace

Send the focused window to a different workspace.

| Shortcut | Target Workspace |
|----------|-----------------|
| Super + Shift + 1 | Workspace 1 |
| Super + Shift + 2 | Workspace 2 |
| Super + Shift + 3 | Workspace 3 |
| Super + Shift + 4 | Workspace 4 |
| Super + Shift + 5 | Workspace 5 |
| Super + Shift + 6 | Workspace 6 |
| Super + Shift + 7 | Workspace 7 |
| Super + Shift + 8 | Workspace 8 |
| Super + Shift + 9 | Workspace 9 |
| Super + Shift + 0 | Workspace 10 |

### Special Workspace

| Shortcut | Action |
|----------|--------|
| Super + Shift + S | Move to scratchpad |

**Notes**:
- Window moves but focus stays on original workspace
- Add `&& hyprctl dispatch workspace N` to follow window

---

## Wallpaper Controls

| Shortcut | Action | Description |
|----------|--------|-------------|
| Super + Shift + W | wallpaper-picker | Visual wallpaper selector |
| Super + Ctrl + W | random-wallpaper | Random wallpaper with random transition |

**Wallpaper Picker Features**:
- Rofi interface with image thumbnails
- 120px preview images
- Search/filter by name
- Shows 4 wallpapers at once
- Smooth wipe transition on selection

**Random Wallpaper**:
- Picks from `~/Pictures/wallpapers`
- Random transition effect
- Automatically saves selection

**Wallpaper Directory**:
- Location: `~/Pictures/wallpapers`
- Supported: jpg, jpeg, png, webp
- Thumbnails cached in `~/.cache/wallpaper-thumbnails`

---

## System Controls

| Shortcut | Action | Description |
|----------|--------|-------------|
| Print | Screenshot area | Select area, copy to clipboard |
| Shift + Print | Screenshot full | Full screen to clipboard |
| Super + Alt + W | Restart Waybar | Reload status bar |

**Screenshot Tool**: grim + slurp
- Select area with mouse
- Automatically copies to clipboard
- Paste with Ctrl+V

---

## Mouse Bindings

| Action | Description |
|--------|-------------|
| Super + Left Click | Move window |
| Super + Right Click | Resize window |

**Mouse Window Control**:
- Hold Super and drag to move floating windows
- Hold Super and right-drag to resize
- Works on tiled windows (temporarily floats them)
- Release to snap back to tile (if was tiled)

---

## Rofi Navigation

When rofi is open (app launcher, wallpaper picker, cheatsheet):

| Key | Action |
|-----|--------|
| Arrow Keys | Navigate items |
| Enter | Select item |
| Escape | Cancel/close |
| Type | Filter/search |
| Tab | Next item |
| Shift + Tab | Previous item |

---

## Terminal Shortcuts

### Ghostty (Primary Terminal)

Default terminal keybindings apply. Configuration in Ghostty's config.

### Alacritty (Alternative)

| Shortcut | Action |
|----------|--------|
| Ctrl + N | New instance |
| Ctrl + Shift + C | Copy |
| Ctrl + Shift + V | Paste |

---

## Waybar Interactions

Click interactions on Waybar modules:

| Module | Click Action |
|--------|--------------|
| Network | Open nm-connection-editor |
| Audio | Open pavucontrol |
| Workspaces | Switch to workspace |
| Window Title | (No action) |
| System Tray | App-specific menus |
| Clock | Show calendar (hover) |

**Clock Formats**:
- Default: Icon + HH:MM (e.g., 󰥔 14:30)
- Alt-click: Icon + Full date (e.g., 󰃭 Friday, December 06, 2025)

---

## Zsh Shell Shortcuts

In terminal (Zsh with Oh My Zsh):

### History

| Shortcut | Action |
|----------|--------|
| Ctrl + R | Reverse search history |
| Up/Down | History navigation with substring search |
| Ctrl + P/N | Previous/Next command |

### Editing

| Shortcut | Action |
|----------|--------|
| Ctrl + A | Beginning of line |
| Ctrl + E | End of line |
| Ctrl + U | Clear line |
| Ctrl + K | Cut to end of line |
| Ctrl + W | Delete word backward |
| Alt + D | Delete word forward |

### Other

| Shortcut | Action |
|----------|--------|
| Tab | Autocomplete |
| Ctrl + L | Clear screen |
| Ctrl + D | Exit shell |
| Ctrl + Z | Suspend process |

**sudo plugin**:
- Press `Esc` twice to add `sudo` to current command

---

## Application-Specific Shortcuts

### Firefox

Standard Firefox shortcuts apply:
- Ctrl + T: New tab
- Ctrl + W: Close tab
- Ctrl + Shift + T: Reopen closed tab
- Ctrl + L: Focus address bar
- Ctrl + Tab: Next tab

### VSCode

Standard VSCode shortcuts apply:
- Ctrl + Shift + P: Command palette
- Ctrl + P: Quick open file
- Ctrl + B: Toggle sidebar
- Ctrl + \`: Toggle terminal

---

## Customizing Keybindings

### Hyprland Keybindings

Edit `home/modules/hypr/hyprland.nix`:

```nix
bind = [
  # Add new keybinding
  "$mod, KEY, action, argument"
];
```

**Common Actions**:
- `exec` - Execute command
- `killactive` - Close window
- `workspace` - Switch workspace
- `movetoworkspace` - Move window
- `togglefloating` - Float/tile window
- `fullscreen` - Fullscreen mode

**Example**:
```nix
"$mod, T, exec, alacritty"  # Super+T opens Alacritty
```

### Modifier Keys

Available modifiers:
- `SUPER` (Windows key)
- `SHIFT`
- `CTRL`
- `ALT`

Combine with space:
- `$mod SHIFT` - Super + Shift
- `$mod CTRL` - Super + Ctrl
- `$mod ALT` - Super + Alt

### Mouse Bindings

Edit `bindm` section:

```nix
bindm = [
  "$mod, mouse:272, movewindow"    # Left click
  "$mod, mouse:273, resizewindow"  # Right click
];
```

---

## Tips and Tricks

### Quick Window Switching
- Super + Number switches to workspace
- Windows on that workspace become accessible
- Use scratchpad (Super+S) for temporary windows

### Efficient Workspace Usage
- Organize by task (1=browser, 2=code, 3=terminal, etc.)
- Use Super+Shift+Number to send windows
- Empty workspaces auto-close

### Floating Window Management
- Super+V to toggle float
- Super+Mouse to move
- Super+Right-Mouse to resize
- Useful for calculators, dialogs, picture-in-picture

### Scratchpad Usage
- Super+S toggles scratchpad visibility
- Super+Shift+S sends window to scratchpad
- Perfect for music player, notes, chat
- Hidden but quickly accessible

### Wallpaper Tips
- Keep wallpapers in `~/Pictures/wallpapers`
- Thumbnails auto-generate once
- Super+Ctrl+W for variety (random)
- Super+Shift+W for specific choice

---

## Conflicting Keybindings

### Known Conflicts

**None currently identified**

### If Keybinding Doesn't Work

1. Check if application has its own binding
2. Verify Hyprland config syntax
3. Test with `hyprctl dispatch`
4. Check logs: `journalctl -u hyprland`

### Testing New Keybindings

```bash
# Test without rebuilding
hyprctl keyword bind SUPER,T,exec,alacritty

# Make permanent by adding to hyprland.nix
```

---

## See Also

- [Hyprland Documentation](hyprland.md) - Full Hyprland configuration
- [Workflows](workflows.md) - Common task procedures
- Built-in cheatsheet: Press **Super+K**
