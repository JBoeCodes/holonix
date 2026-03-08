{ pkgs, ... }:

let
  configText = ''
    # Typography
    font-family = JetBrainsMonoNerdFont
    font-size = 14
    font-thicken = true
    adjust-cell-height = 2

    # Theme and Colors
    theme = light:Catppuccin Latte,dark:Catppuccin Mocha

    # Window and Appearance
    background-opacity = 0.9
    background-blur-radius = 20
    window-padding-x = 10
    window-padding-y = 8
    window-save-state = always
    window-theme = auto

    # Cursor
    cursor-style = bar
    cursor-style-blink = true
    cursor-opacity = 0.8

    # Mouse
    mouse-hide-while-typing = true
    copy-on-select = clipboard

    # Quick Terminal (Quake-style dropdown)
    quick-terminal-position = top
    quick-terminal-screen = mouse
    quick-terminal-autohide = true
    quick-terminal-animation-duration = 0.15

    # Security
    clipboard-paste-protection = true
    clipboard-paste-bracketed-safe = true

    # Shell Integration
    shell-integration = detect

    # Keybindings (Linux - using ctrl instead of cmd)
    # Tabs
    keybind = ctrl+t=new_tab
    keybind = ctrl+shift+left=previous_tab
    keybind = ctrl+shift+right=next_tab
    keybind = ctrl+w=close_surface

    # Splits
    keybind = ctrl+d=new_split:right
    keybind = ctrl+shift+d=new_split:down
    keybind = ctrl+alt+left=goto_split:left
    keybind = ctrl+alt+right=goto_split:right
    keybind = ctrl+alt+up=goto_split:top
    keybind = ctrl+alt+down=goto_split:bottom

    # Font size
    keybind = ctrl+plus=increase_font_size:1
    keybind = ctrl+minus=decrease_font_size:1
    keybind = ctrl+zero=reset_font_size

    # Quick terminal global hotkey
    keybind = global:ctrl+grave_accent=toggle_quick_terminal

    # Splits management
    keybind = ctrl+shift+e=equalize_splits
    keybind = ctrl+shift+f=toggle_split_zoom

    # Reload config
    keybind = ctrl+shift+comma=reload_config

    # Performance
    scrollback-limit = 25000000
  '';

  configFile = pkgs.writeText "ghostty-config" configText;
in
{
  users.users.jboe.packages = [ pkgs.ghostty ];

  system.activationScripts.ghosttyConfig = ''
    dir="/home/jboe/.config/ghostty"
    mkdir -p "$dir"
    ln -sf ${configFile} "$dir/config"
    chown -h jboe:users "$dir/config"
  '';
}
