# Module Reference

Complete documentation of all NixOS modules in this configuration.

## Module Index

All modules are imported through `modules/default.nix`. Never import modules directly in `configuration.nix`.

### Module Categories

| Category | Purpose | Location |
|----------|---------|----------|
| config/ | System-wide configuration | `modules/config/` |
| display/ | Desktop environments | `modules/display/` |
| hardware/ | Hardware-specific settings | `modules/hardware/` |
| network/ | Network configuration | `modules/network/` |
| system/ | Core system services | `modules/system/` |
| tools/ | Application configs | `modules/tools/` |

---

## Config Modules

System-wide configuration settings.

### fonts.nix

**Purpose**: Install and configure system fonts

**Configuration**:
```nix
fonts.packages = with pkgs; [
  (nerdfonts.override { fonts = [ "Hack" ]; })
];
```

**Provides**:
- Hack Nerd Font (includes icons and symbols)
- Used by: Waybar, Rofi, terminals, system UI

**Notes**:
- Nerd Fonts include Material Design Icons, Font Awesome, Powerline symbols
- Only Hack variant installed to save space
- Needed for icons in Waybar and other UI elements

---

### locale.nix

**Purpose**: System locale and keyboard configuration

**Configuration**:
```nix
time.timeZone = "America/New_York";
i18n.defaultLocale = "en_US.UTF-8";
services.xserver.xkb.layout = "us";
```

**Settings**:
- **Timezone**: America/New_York (Eastern Time)
- **Locale**: en_US.UTF-8
- **Keyboard Layout**: US (QWERTY)

**Notes**:
- Timezone affects system time, logs, timestamps
- Locale affects date/time formatting, currency
- Keyboard layout applies to X11 and Wayland

---

### user.nix

**Purpose**: User account configuration

**Configuration**:
```nix
users.users.jboe = {
  isNormalUser = true;
  description = "jboe";
  extraGroups = [ "networkmanager" "wheel" ];
  shell = pkgs.zsh;
};
programs.zsh.enable = true;
```

**User Details**:
- **Username**: jboe
- **Type**: Normal user (not system)
- **Shell**: Zsh
- **Groups**:
  - `wheel` - sudo/admin access
  - `networkmanager` - network configuration

**Notes**:
- Zsh must be enabled at system level to use as user shell
- Home directory: `/home/jboe`
- Password set outside of configuration (security)

---

## Display Modules

Desktop environment and display server configuration.

### gnome.nix

**Purpose**: GNOME Desktop Environment

**Status**: Conditionally enabled for all four hosts

**Services Enabled**:
- `services.xserver.enable = true`
- `services.xserver.displayManager.gdm.enable = true`
- `services.xserver.desktopManager.gnome.enable = true`
- `services.gnome.core-utilities.enable = true`

**Packages Installed**:
- **GNOME Core Apps**: Nautilus, Settings, Terminal, Calendar, etc.
- **System Tools**: dconf-editor, gnome-tweaks
- **Extensions**: AppIndicator support
- **Customization**: gnome-themes-extra

**Features**:
- Wayland by default
- GDM display manager
- Full GNOME experience
- Qt application theming (Adwaita)
- XDG portal configuration
- Location services (geoclue2)

**Notes**:
- Available as fallback to Hyprland
- Full-featured desktop environment
- Good for troubleshooting Hyprland issues

---

### hyprland.nix

**Purpose**: Hyprland Wayland compositor (via Home Manager)

**Location**: `home/modules/hypr/hyprland.nix`

**Key Settings**:
- **Monitor**: Preferred resolution, 1.6 scale (jboebook)
- **Layout**: Dwindle
- **Animations**: Enabled with custom bezier curves
- **Gaps**: 5px inner, 10px outer
- **Border**: 2px, gradient colors
- **Rounding**: 10px

**Autostart Programs**:
- Waybar (status bar)
- Dunst (notifications)
- swww-daemon (wallpaper)
- restore-wallpaper script

**Colors**:
- Active border: Cyan to green gradient (`rgba(33ccffee)` → `rgba(00ff99ee)`)
- Inactive border: Gray (`rgba(595959aa)`)

**Special Features**:
- Touchpad natural scrolling
- Workspace scratchpad (special:magic)
- Window tearing disabled
- Suppress maximize events

**Configuration**: See [hyprland.md](hyprland.md) for full details

---

## Hardware Modules

Hardware-specific configuration.

### audio.nix

**Purpose**: Audio system configuration

**Configuration**:
```nix
security.rtkit.enable = true;
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  jack.enable = true;
};
```

**Features**:
- **PipeWire**: Modern audio server (replaces PulseAudio)
- **ALSA Support**: Direct hardware access
- **PulseAudio Compatibility**: Existing apps work
- **JACK Support**: Pro audio applications
- **32-bit Support**: For older software/games
- **Real-time Kit**: Low-latency audio

**Notes**:
- PipeWire is lower latency than PulseAudio
- Compatible with all PulseAudio applications
- JACK support for professional audio work
- Required for screen recording with audio

---

### nvidia.nix

**Purpose**: NVIDIA graphics drivers

**Enabled For**: jboedesk only

**Configuration**:
```nix
programs.nvidia.enable = lib.mkIf (config.networking.hostName == "jboedesk") true;
services.xserver.videoDrivers = [ "nvidia" ];
hardware.nvidia = {
  modesetting.enable = true;
  package = config.boot.kernelPackages.nvidiaPackages.stable;
};
hardware.graphics.enable32Bit = true;
```

**Features**:
- Stable driver branch
- Kernel modesetting enabled
- Proprietary drivers
- 32-bit support for gaming
- OpenGL 32-bit libraries

**Notes**:
- Only active on jboedesk (conditional)
- Required for NVIDIA GPUs
- 32-bit support needed for Steam games
- Modesetting improves Wayland compatibility

---

## Network Modules

Network configuration and connectivity.

### networking.nix

**Purpose**: Network management

**Configuration**:
```nix
networking.networkmanager.enable = true;
users.users.jboe.extraGroups = [ "networkmanager" ];
```

**Features**:
- NetworkManager for connection management
- User can manage networks without sudo
- Graphical network configuration tools
- WiFi and ethernet support

**Tools Available**:
- `nmcli` - Command-line interface
- `nm-connection-editor` - GUI configuration
- `nmtui` - Terminal UI

---

### smb.nix

**Purpose**: Windows file sharing (SMB/CIFS)

**Configuration**:
```nix
services.gvfs.enable = true;
environment.systemPackages = with pkgs; [
  cifs-utils
];
```

**Features**:
- GVFS integration (GNOME Virtual File System)
- Mount SMB shares
- Access Windows network drives
- Nautilus integration

**Usage**:
- Access SMB shares in file manager
- URI format: `smb://server/share`
- Automatic discovery in Nautilus

---

## System Modules

Core system services and configuration.

### boot.nix

**Purpose**: Boot loader and kernel configuration

**Configuration**:
```nix
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;
boot.consoleLogLevel = 0;
boot.kernelParams = [ "quiet" "udev.log_level=3" ];
```

**Features**:
- **Bootloader**: systemd-boot (simple, fast)
- **EFI Support**: Can modify EFI variables
- **Quiet Boot**: Minimal console output
- **Reduced Logging**: Less verbose boot messages

**Notes**:
- systemd-boot is simpler than GRUB
- Quiet boot for cleaner experience
- Boot menu still accessible (hold Space during boot)

---

### nix.nix

**Purpose**: Nix package manager configuration

**Configuration**:
```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
nixpkgs.config.allowUnfree = true;
```

**Features**:
- **Flakes**: Modern Nix configuration format
- **Nix Command**: New CLI interface (`nix build`, etc.)
- **Unfree Packages**: Allow proprietary software

**Enabled Features**:
- Flake-based configuration
- Declarative dependencies
- Reproducible builds
- Unfree software (Steam, NVIDIA drivers, etc.)

**Notes**:
- Flakes are essential for this configuration
- Unfree needed for many packages (VSCode, Spotify, etc.)
- Experimental features are stable enough for daily use

---

### printing.nix

**Purpose**: Printer support

**Configuration**:
```nix
services.printing.enable = true;
```

**Features**:
- CUPS printing system
- Network printer discovery
- PDF printing
- Various printer driver support

**Notes**:
- Minimal configuration
- Printers auto-discovered on network
- Additional drivers can be added via packages

---

### steam.nix

**Purpose**: Steam gaming platform

**Configuration**:
```nix
programs.steam = {
  enable = true;
  remotePlay.openFirewall = true;
  dedicatedServer.openFirewall = true;
  localNetworkGameTransfers.openFirewall = true;
};
```

**Features**:
- Steam client installation
- Remote Play support (stream games)
- Dedicated server hosting
- Local network game transfers
- Firewall rules automatically configured

**Notes**:
- Includes 32-bit libraries for games
- Requires unfree packages enabled
- Works with NVIDIA drivers on jboedesk

---

## Home Manager Modules

User-level configuration (all in `home/modules/`).

**Imported Modules** (from `home/home.nix`):
- `kitty.nix` - Kitty terminal emulator
- `packages.nix` - User packages
- `zsh.nix` - Zsh shell configuration
- `fastfetch.nix` - System info display (added 2025-12-07)
- `matugen.nix` - Theme generation system
- `hypr/hyprland.nix` - Hyprland compositor
- `hypr/rofi.nix` - Application launcher
- `hypr/waybar.nix` - Status bar
- `hypr/theme-picker.nix` - Wallpaper/theme picker
- `hypr/keybind-cheatsheet.nix` - Keybinding reference

### packages.nix

**Purpose**: User-installed packages

**Categories**:

**Development Tools**:
- neovim, claude-code, git
- firefox, VSCode (from nixpad originally)

**Browsers**:
- brave (default via XDG MIME)
- firefox

**Media**:
- spotify, strawberry, cmus, mpv
- imagemagick, ffmpeg

**Utilities**:
- obsidian (notes)
- parsec-bin (remote desktop)

**Modern CLI Tools**:
- bat (better cat)
- eza (better ls)
- fd (better find)
- btop (better top)
- fastfetch (neofetch replacement)
- dust (better du)
- zoxide (smart cd)
- fzf (fuzzy finder)

**System Tools**:
- nixfmt-classic (Nix formatter)
- libnotify (notifications)

**Notes**:
- Shared across all hosts
- Can be overridden per-host if needed
- Brave set as default browser via XDG associations

---

### zsh.nix

**Purpose**: Zsh shell configuration with Oh My Zsh

**Configuration**:
- **Framework**: Oh My Zsh
- **Theme**: robbyrussell
- **Plugins**: git, sudo, history-substring-search, colored-man-pages, command-not-found

**Aliases**:

**Modern CLI**:
- `ls` → `eza -la --icons`
- `cat` → `bat`
- `find` → `fd`
- `cd` → `z` (zoxide)

**System Tools**:
- `htop` → `btop`
- `neofetch` → `fastfetch`

**NixOS Shortcuts**:
- `nrs` → rebuild switch
- `nrt` → rebuild test
- `nrb` → rebuild boot
- `nfu` → flake update
- `nfc` → flake check
- `nixai` → AI-assisted config editing (cd ~/nixos && claude)

**Features**:
- Zoxide for smart directory jumping
- Syntax highlighting
- History substring search (arrows search history)
- Colored man pages
- Git integration
- Fastfetch runs automatically on shell startup (interactive shells only)

**Auto-Start Programs**:
- Fastfetch system info display with personal greeting

**Known Issue**:
- Host-specific aliases reference "nixpad" hardcoded
- Should be updated per-host or made dynamic

---

### fastfetch.nix

**Purpose**: System information display with aesthetic configuration

**Configuration**:
- Personal greeting: "Hello, Jameson"
- Material Design icon symbols
- Colored output (blue keys, cyan title)
- Comprehensive system info display

**Information Displayed**:
- User and hostname title
- OS and kernel details
- Desktop environment (DE/WM)
- Terminal and font info
- Hardware specs (CPU, GPU)
- Memory and disk usage
- Battery status (laptops)
- Color palette visualization

**Features**:
- Runs automatically on shell startup
- Clean, organized layout with separators
- Adapts to current system configuration
- Fast startup (<100ms)

**Location**: `home/modules/fastfetch.nix`

**Notes**:
- Replaces neofetch (faster, more maintained)
- Config file: `~/.config/fastfetch/config.jsonc`
- Runs on every interactive shell (zsh)
- Can be disabled by removing from zsh initContent

---

### alacritty.nix

**Purpose**: Alacritty terminal emulator

**Configuration**:
- **Opacity**: 80% (0.8)
- **Decorations**: None (titlebar disabled)
- **Font**: Hack Nerd Font Mono, 11pt
- **Color Scheme**: Gruvbox-inspired custom theme

**Colors**:
- Background: `#1d2021` (dark)
- Foreground: `#ebdbb2` (light)
- Cursor: Yellow `#fabd2f`
- Custom 16-color palette

**Keybindings**:
- `Ctrl+N` - New instance
- Standard copy/paste shortcuts

**Notes**:
- Available as alternative to kitty and Ghostty
- Transparent background for aesthetics
- No window decorations for tiling WM compatibility

---

### kitty.nix

**Purpose**: Kitty terminal emulator

**Configuration**:
- **Theme**: Dynamic colors from matugen (wallpaper-based)
- **Window Decoration**: None (titlebar disabled)
- **Opacity**: 75% (0.75) - Updated 2025-12-07
- **Font**: Hack Nerd Font Mono, 12pt
- **Padding**: 25px
- **Cursor**: Beam style, no blinking

**Remote Control**:
- **Enabled**: Yes (for theme hot-reloading)
- **Socket**: `unix:/tmp/kitty` (instance-specific)
- **Protocol**: Kitty remote control protocol

**Theme Integration**:
- Automatically uses colors generated from wallpaper
- Theme file: `~/.config/kitty/theme.conf`
- Generated by matugen from Material Design 3 palette
- Hot-reloads when wallpaper changes (all instances)
- No need to close/reopen terminal to see new colors

**Keybindings**:
- `Ctrl+N` - New window

**Notes**:
- GPU-accelerated terminal
- Native Wayland support
- Theme auto-reloads via theme-picker script
- All kitty instances update simultaneously
- More transparent than default (75% vs 85%)

**Location**: `home/modules/kitty.nix`

---

### ghostty.nix

**Purpose**: Ghostty terminal emulator (alternative)

**Keybinding**: Can be configured as alternative to kitty

**Configuration**:
- **Theme**: Dynamic colors from matugen (wallpaper-based)
- **Window Decoration**: None (titlebar disabled)
- **Opacity**: 85% (0.85)
- **Font**: Hack Nerd Font Mono, 12pt
- **Padding**: 25px horizontal, 20px vertical
- **Cursor**: Bar style, no blinking

**Theme Integration**:
- Automatically uses colors generated from wallpaper
- Theme file: `~/.config/ghostty/theme`
- Generated by matugen from Material Design 3 palette
- Updates when wallpaper changes

**Keybindings**:
- `Ctrl+N` - New window

**Notes**:
- Modern GPU-accelerated terminal
- Native Wayland support
- Very fast and lightweight
- Theme adapts to current wallpaper colors

---

## Hyprland Modules

Hyprland-specific configuration (in `home/modules/hypr/`).

### rofi.nix

**Purpose**: Application launcher styling

**Theme**: Custom theme with matugen color integration

**Configuration**:
- Rounded corners (12px)
- Transparency
- Dynamic colors from matugen
- Icon support
- Grid layout for drun mode

**Theme Integration**:
- Imports colors from `~/.config/rofi/colors.rasi`
- Generated by matugen from wallpaper
- Updates automatically when theme changes
- No circular variable references (fixed 2025-12-07)

**Features**:
- Application launcher (drun)
- Window switcher
- Run command
- Custom scripts (wallpaper picker, keybind cheatsheet)

**Recent Fixes** (2025-12-07):
- Removed circular `urgent: @urgent` variable reference
- Fixed "validating the theme failed" error
- Theme now validates correctly on launch

**Location**: `home/modules/hypr/rofi.nix`

---

### waybar.nix

**Purpose**: Status bar configuration

**Layout**:
- **Left**: Workspaces, Submap
- **Center**: Window title with app icon
- **Right**: Audio, Network, CPU, Memory, Battery, Clock, Tray

**Modules**:

**Workspaces** (hyprland/workspaces):
- Shows all workspaces
- Click to activate
- Visual indicators for active/urgent

**Window Title** (hyprland/window):
- Shows active window
- Application icon (180px)
- Max 60 characters
- Updated in recent session to show app icons

**Clock**:
- Format: Icon + HH:MM
- Alt format: Date
- Calendar in tooltip

**System Monitors**:
- CPU usage with icon
- Memory usage with icon
- 2-second update interval

**Battery**:
- Percentage with icon
- Warning at 30%
- Critical at 15%
- Shows charging state
- Multiple icon states

**Network**:
- WiFi ESSID
- Ethernet status
- Click opens nm-connection-editor
- Bandwidth in tooltip

**Audio** (PulseAudio):
- Volume with icon
- Muted indicator
- Click opens pavucontrol
- Different icons for output types

**System Tray**:
- 18px icons
- Shows background apps

**Theme**:
- Catppuccin Mocha colors
- Rounded modules (12px)
- Transparency
- Smooth transitions
- Gradients on active elements
- Box shadows

**Recent Updates**:
- Added application icons to window title
- Enabled icon preview for active window

---

### wallpaper-picker.nix

**Purpose**: Visual wallpaper selection with rofi

**Features**:
- Rofi-based interface
- Image thumbnails (200x200)
- Thumbnail caching
- Wallpaper name display
- Search/filter capability

**Configuration**:
- **Wallpaper Directory**: `~/Pictures/wallpapers`
- **Cache Directory**: `~/.cache/wallpaper-thumbnails`
- **Supported Formats**: jpg, jpeg, png, webp

**Scripts Provided**:

**wallpaper-picker**:
- Main picker with visual thumbnails
- Rofi shows 120px previews
- 4 items visible, scrollable
- Click to apply wallpaper
- Uses swww for transitions

**restore-wallpaper**:
- Runs on startup
- Restores last wallpaper
- Waits for swww daemon

**random-wallpaper**:
- Selects random wallpaper
- Random transition effect
- Saves selection

**Transition Effects**:
- Type: wipe (picker), random (random)
- Duration: 2 seconds
- FPS: 60
- Angle: 30 degrees (wipe)

**Recent Fixes**:
- Fixed bash syntax errors (removed invalid stderr redirects)
- Switched from yad to rofi for better integration
- Implemented native rofi thumbnail support
- Adjusted sizing to fit on screen (was extending off edges)
- Used `\0icon\x1f` format for rofi image previews

**Known Solution**:
Rofi supports native image thumbnails using:
```bash
echo -en "name\0icon\x1f/path/to/image.jpg\n"
```

---

### keybind-cheatsheet.nix

**Purpose**: Display keyboard shortcuts reference

**Features**:
- Rofi-based cheatsheet
- All shortcuts categorized
- Searchable/filterable
- Well-formatted display

**Categories**:
- Program Launches
- Window Management
- Focus Movement
- Workspace Switching
- Move Windows
- Wallpaper Controls
- System Commands
- Mouse Controls

**Keybinding**: Super+K

**Display**:
- Custom rofi theme
- 900x700 window
- 30 lines visible
- Monospace font for alignment
- Easy to read formatting

---

### matugen.nix

**Purpose**: Dynamic theme generation from wallpaper

**Location**: `home/modules/matugen.nix`

**What it Does**:
Matugen extracts a Material Design 3 color palette from your wallpaper and generates theme files for all applications.

**Configured Applications**:
- **Hyprland** - Border colors (`~/.config/hypr/colors.conf`)
- **Waybar** - Status bar colors (`~/.config/waybar/colors.css`)
- **Rofi** - Launcher colors (`~/.config/rofi/colors.rasi`)
- **Ghostty** - Terminal colors (`~/.config/ghostty/theme`)

**Template System**:
Matugen uses templates to generate config files:
- Templates: `~/.config/matugen/templates/`
- Output: Various app config directories
- Triggered: When wallpaper changes via theme-picker

**Color Variables**:
Templates use Mustache syntax with `hex_stripped` for compatibility:
```
# For CSS/Rasi (needs # prefix)
color: #{{colors.primary.default.hex_stripped}};

# For Hyprland rgba() (no prefix)
col.active_border = rgb({{colors.primary.default.hex_stripped}})

# For RGB decimal values
rgba({{colors.primary.default.red}}, {{colors.primary.default.green}}, {{colors.primary.default.blue}}, 0.95)
```

**Application Reload**:
```toml
reload_apps = true
reload_apps_list = { waybar = "pkill waybar; waybar &", hyprland = "hyprctl reload" }
```

**Color Palette**:
- Primary, Secondary, Tertiary colors
- Surface colors (backgrounds)
- Error colors
- Each with "on-" variants for text
- Container variants for surfaces

**How to Use**:
1. Run theme-picker (Super+Shift+W)
2. Select wallpaper
3. Matugen generates colors automatically
4. All apps reload with new theme

**Benefits**:
- Cohesive color scheme across all apps
- Automatically adapts to wallpaper
- Material Design 3 aesthetics
- No manual color picking needed

**Important Notes**:
- Use `hex_stripped` in templates (not `hex`) to avoid double `##`
- Hyprland needs plain hex values in `rgb()`/`rgba()`
- CSS/Rasi need `#` prefix manually added in template
- Templates regenerate color files when wallpaper changes

---

### theme-picker.nix

**Purpose**: Visual wallpaper and theme selection

**Location**: `home/modules/hypr/theme-picker.nix`

**Features**:
- Rofi-based interface for wallpaper selection
- Automatically runs matugen to generate theme
- Updates all applications with new colors
- Smooth wallpaper transitions with swww
- Hot-reloads kitty terminal colors (all instances)

**Keybinding**: Super+Shift+W

**How It Works**:
1. User selects wallpaper from rofi
2. Sets wallpaper with swww
3. Runs matugen to extract colors
4. Matugen generates config files for all apps
5. Applications reload automatically:
   - Waybar (restarts)
   - Hyprland (reloads config)
   - Kitty (hot-reloads all instances)

**Kitty Theme Reload** (Improved 2025-12-07):
- Loops through all kitty socket files (`/tmp/kitty-*`)
- Sends color update to each instance
- No need to close/reopen terminals
- All kitty windows update simultaneously

**Related Scripts**:
- `random-wallpaper` - Random wallpaper/theme (Super+Ctrl+W)
- `restore-wallpaper` - Restore on startup

**Notes**:
- Integrates wallpaper and theming into single action
- Ensures visual consistency across desktop
- Part of the matugen ecosystem
- Kitty remote control must be enabled

---

## Adding New Modules

### Process

1. **Choose category** - config, display, hardware, network, system, or tools
2. **Create module file**:
   ```nix
   # modules/category/new-module.nix
   { config, pkgs, lib, ... }:
   {
     # Configuration here
   }
   ```
3. **Import in modules/default.nix**:
   ```nix
   imports = [
     # ... existing imports
     ./category/new-module.nix
   ];
   ```
4. **Add to git**: `git add modules/category/new-module.nix`
5. **Validate**: `nix flake check`
6. **Rebuild**: `sudo nixos-rebuild switch --flake .#hostname`

### Best Practices

- **One purpose per module** - Keep modules focused
- **Use descriptive names** - Module name should indicate function
- **Add comments** - Explain non-obvious configuration
- **Use conditionals** - For host-specific features
- **Document** - Update this file when adding modules

### Example: Adding Bluetooth Support

```nix
# modules/hardware/bluetooth.nix
{ config, pkgs, ... }:

{
  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Bluetooth manager
  services.blueman.enable = true;
}
```

Then import in `modules/default.nix`:
```nix
./hardware/bluetooth.nix
```
