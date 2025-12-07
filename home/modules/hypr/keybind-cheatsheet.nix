{ config, pkgs, ... }:

{
  # Keybinding cheatsheet script
  home.file.".local/bin/keybind-cheatsheet" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Keybinding cheatsheet - organized by category
      cheatsheet=$(cat <<'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                    HYPRLAND KEYBOARD SHORTCUTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  PROGRAM LAUNCHES
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Super + Return          Launch terminal (Kitty)
  Super + Space           Application launcher (Rofi)
  Super + B               Launch Firefox
  Super + E               Launch file manager (Nautilus)
  Super + K               Show this cheatsheet

  WINDOW MANAGEMENT
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Super + Q/W             Close active window
  Super + M               Exit Hyprland
  Super + V               Toggle floating mode
  Super + F               Toggle fullscreen
  Super + P               Toggle pseudotile
  Super + J               Toggle split direction

  FOCUS MOVEMENT
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Super + Arrow Keys      Move focus between windows
  Super + H/J/K/L         Move focus (Vim keys)

  WORKSPACE SWITCHING
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Super + 1-9/0           Switch to workspace 1-10
  Super + Scroll          Cycle through workspaces
  Super + S               Toggle scratchpad workspace

  MOVE WINDOWS
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Super + Shift + 1-9/0   Move window to workspace 1-10
  Super + Shift + S       Move window to scratchpad

  WALLPAPER
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Super + Shift + W       Choose wallpaper
  Super + Ctrl + W        Random wallpaper

  SYSTEM
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Print                   Screenshot area (clipboard)
  Shift + Print           Screenshot full screen (clipboard)
  Super + Alt + W         Restart Waybar

  MOUSE
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Super + Left Click      Move window
  Super + Right Click     Resize window

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
      )

      # Display in rofi with custom styling
      echo "$cheatsheet" | ${pkgs.rofi}/bin/rofi -dmenu \
        -i \
        -p "  Keybindings" \
        -theme-str 'window {width: 900px; height: 700px;} listview {lines: 30; columns: 1;} element-text {font: "Hack Nerd Font Mono 11";}'
    '';
  };
}
