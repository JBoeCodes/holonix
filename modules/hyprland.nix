{ pkgs, ... }:

let
  hyprlandConfig = ''
    ################
    ### MONITORS ###
    ################
    monitor = , preferred, auto, 1, vrr, 2

    #################
    ### AUTOSTART ###
    #################
    exec-once = waybar
    exec-once = swaync
    exec-once = swww-daemon
    exec-once = wl-paste --type text --watch cliphist store
    exec-once = wl-paste --type image --watch cliphist store
    exec-once = hyprpolkitagent
    exec-once = hypridle
    exec-once = hyprsunset -t 4500
    exec-once = nm-applet --indicator
    exec-once = waypaper --restore

    # Scratchpad terminals
    exec-once = ghostty --class=dropdown-terminal
    exec-once = ghostty --class=lazygit-scratch -e lazygit
    exec-once = ghostty --class=btop-scratch -e btop

    # Portal conflict workaround: kill GNOME portal, restart Hyprland portal
    exec-once = sleep 1 && systemctl --user stop xdg-desktop-portal-gnome.service && systemctl --user restart xdg-desktop-portal-hyprland.service && systemctl --user restart xdg-desktop-portal.service

    #############################
    ### ENVIRONMENT VARIABLES ###
    #############################

    # NVIDIA
    env = LIBVA_DRIVER_NAME,nvidia
    env = XDG_SESSION_TYPE,wayland
    env = GBM_BACKEND,nvidia-drm
    env = __GLX_VENDOR_LIBRARY_NAME,nvidia
    env = NIXOS_OZONE_WL,1
    env = NVD_BACKEND,direct
    env = __GL_GSYNC_ALLOWED,1
    env = __GL_VRR_ALLOWED,1

    # Cursor
    env = XCURSOR_SIZE,24
    env = HYPRCURSOR_SIZE,24

    #####################
    ### LOOK AND FEEL ###
    #####################
    general {
        gaps_in = 5
        gaps_out = 10
        border_size = 2
        col.active_border = rgb(cba6f7) rgb(89b4fa) rgb(a6e3a1) 45deg
        col.inactive_border = rgba(585b7066)
        layout = dwindle
        allow_tearing = true
    }

    decoration {
        rounding = 12
        active_opacity = 0.92
        inactive_opacity = 0.85
        fullscreen_opacity = 1.0

        shadow {
            enabled = true
            range = 15
            render_power = 3
            color = rgba(0, 0, 0, 0.55)
            offset = 0 4
        }

        blur {
            enabled = true
            size = 10
            passes = 4
            new_optimizations = true
            ignore_opacity = true
            special = true
            popups = true
            popups_ignorealpha = 0.6
            noise = 0.02
            xray = false
        }

        dim_inactive = true
        dim_strength = 0.15
    }

    animations {
        enabled = true
        bezier = wind, 0.05, 0.9, 0.1, 1.05
        bezier = winIn, 0.1, 1.1, 0.1, 1.1
        bezier = winOut, 0.3, -0.3, 0, 1
        bezier = liner, 1, 1, 1, 1
        bezier = md3_decel, 0.05, 0.7, 0.1, 1

        animation = windows, 1, 6, wind, slide
        animation = windowsIn, 1, 5, winIn, slide
        animation = windowsOut, 1, 5, winOut, slide
        animation = windowsMove, 1, 5, wind, slide
        animation = fade, 1, 5, md3_decel
        animation = workspaces, 1, 5, wind, slidevert
        animation = border, 1, 10, liner
        animation = borderangle, 1, 100, liner, loop
    }

    dwindle {
        pseudotile = true
        preserve_split = true
    }

    misc {
        force_default_wallpaper = 0
        disable_hyprland_logo = true
        vfr = true
    }

    cursor {
        no_hardware_cursors = true
    }

    #############
    ### INPUT ###
    #############
    input {
        kb_layout = us
        kb_options = altwin:swap_alt_win
        follow_mouse = 1
        sensitivity = 0
    }

    ####################
    ### KEYBINDINGS  ###
    ####################

    $mod = SUPER

    # Core
    bind = $mod, Return, exec, ghostty
    bind = $mod, Q, killactive
    bind = $mod SHIFT, Q, exit
    bind = $mod, V, togglefloating
    bind = $mod, F, fullscreen
    bind = $mod, P, pseudo
    bind = $mod, J, togglesplit

    # App launcher
    bind = $mod, Space, exec, rofi -show drun -show-icons
    bind = $mod, R, exec, rofi -show run

    # Clipboard history
    bind = $mod SHIFT, V, exec, cliphist list | rofi -dmenu -p Clipboard | cliphist decode | wl-copy
    bind = $mod SHIFT, Delete, exec, cliphist wipe

    # Screenshots
    bind = $mod SHIFT, S, exec, grimblast --notify copy area
    bind = , Print, exec, grimblast --notify copy screen
    bind = $mod, Print, exec, grimblast --notify copy active
    bind = $mod SHIFT, A, exec, grimblast save area - | satty --filename -

    # Screen recording (toggle)
    bind = $mod SHIFT, R, exec, pkill wf-recorder || wf-recorder -g "$(slurp)" -f ~/Videos/recording-$(date +%Y%m%d_%H%M%S).mp4

    # Color picker
    bind = $mod SHIFT, C, exec, hyprpicker -a

    # Wallpaper picker
    bind = $mod SHIFT, W, exec, swww img "$(find ~/wallpapers -type f | shuf -n 1)" --transition-type grow --transition-duration 1.5 --transition-fps 60

    # Scratchpads
    bind = $mod, grave, togglespecialworkspace, dropdown
    bind = $mod SHIFT, grave, movetoworkspace, special:dropdown
    bind = $mod, G, togglespecialworkspace, lazygit
    bind = $mod, B, exec, firefox

    # Notification center
    bind = $mod, N, exec, swaync-client -t -sw

    # 1Password Quick Access (matching your GNOME Ctrl+Shift+Space)
    bind = CTRL SHIFT, Space, exec, 1password --quick-access

    # Dictation (matching your GNOME Super+D)
    bind = $mod, D, exec, dictate

    # Lock screen
    bind = $mod, L, exec, hyprlock

    # Move focus
    bind = $mod, left, movefocus, l
    bind = $mod, right, movefocus, r
    bind = $mod, up, movefocus, u
    bind = $mod, down, movefocus, d

    # Move windows
    bind = $mod SHIFT, left, movewindow, l
    bind = $mod SHIFT, right, movewindow, r
    bind = $mod SHIFT, up, movewindow, u
    bind = $mod SHIFT, down, movewindow, d

    # Resize windows
    binde = $mod CTRL, left, resizeactive, -20 0
    binde = $mod CTRL, right, resizeactive, 20 0
    binde = $mod CTRL, up, resizeactive, 0 -20
    binde = $mod CTRL, down, resizeactive, 0 20

    # Workspaces
    bind = $mod, 1, workspace, 1
    bind = $mod, 2, workspace, 2
    bind = $mod, 3, workspace, 3
    bind = $mod, 4, workspace, 4
    bind = $mod, 5, workspace, 5
    bind = $mod, 6, workspace, 6
    bind = $mod, 7, workspace, 7
    bind = $mod, 8, workspace, 8
    bind = $mod, 9, workspace, 9
    bind = $mod, 0, workspace, 10

    # Move to workspace
    bind = $mod SHIFT, 1, movetoworkspace, 1
    bind = $mod SHIFT, 2, movetoworkspace, 2
    bind = $mod SHIFT, 3, movetoworkspace, 3
    bind = $mod SHIFT, 4, movetoworkspace, 4
    bind = $mod SHIFT, 5, movetoworkspace, 5
    bind = $mod SHIFT, 6, movetoworkspace, 6
    bind = $mod SHIFT, 7, movetoworkspace, 7
    bind = $mod SHIFT, 8, movetoworkspace, 8
    bind = $mod SHIFT, 9, movetoworkspace, 9
    bind = $mod SHIFT, 0, movetoworkspace, 10

    # Scroll through workspaces
    bind = $mod, mouse_down, workspace, e+1
    bind = $mod, mouse_up, workspace, e-1

    # Move/resize with mouse
    bindm = $mod, mouse:272, movewindow
    bindm = $mod, mouse:273, resizewindow

    # Audio (FN keys)
    binde = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    binde = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bind = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

    ##################
    ### LAYER RULES ###
    ##################
    layerrule {
        name = waybar-blur
        blur = on
        ignore_alpha = 0.0
        match:namespace = waybar
    }
    layerrule {
        name = rofi-blur
        blur = on
        ignore_alpha = 0.0
        match:namespace = rofi
    }
    layerrule {
        name = swaync-blur
        blur = on
        ignore_alpha = 0.0
        match:namespace = swaync-control-center
    }
    layerrule {
        name = swaync-notif-blur
        blur = on
        ignore_alpha = 0.0
        match:namespace = swaync-notification-window
    }
    layerrule {
        name = notifications-blur
        blur = on
        ignore_alpha = 0.0
        match:namespace = notifications
    }

    ##############################
    ### WINDOWS AND WORKSPACES ###
    ##############################
    windowrule {
        name = suppress-maximize
        suppress_event = maximize
        match:class = .*
    }
    windowrule {
        name = 1password-float
        float = on
        match:class = ^(1Password)$
    }
    windowrule {
        name = 1password-center
        center = on
        match:class = ^(1Password)$
    }
    windowrule {
        name = 1password-qa-float
        float = on
        match:title = ^(Quick Access — 1Password)$
    }
    windowrule {
        name = 1password-qa-stayfocused
        stay_focused = on
        match:title = ^(Quick Access — 1Password)$
    }

    # Steam game window rules
    windowrule {
        name = steam-game-tearing
        immediate = on
        match:class = ^(steam_app_.*)$
    }
    windowrule {
        name = steam-game-opacity
        opacity = 1.0 override 1.0 override
        match:class = ^(steam_app_.*)$
    }
    windowrule {
        name = steam-game-noblur
        no_blur = on
        match:class = ^(steam_app_.*)$
    }
    windowrule {
        name = steam-game-nodim
        no_dim = on
        match:class = ^(steam_app_.*)$
    }
    windowrule {
        name = steam-game-idleinhibit
        idle_inhibit = fullscreen
        match:class = ^(steam_app_.*)$
    }

    # Steam client floating dialogs
    windowrule {
        name = steam-float
        float = on
        match:class = ^(steam)$
        match:title = ^(Friends List|Settings)$
    }

    # Browser idle inhibit for fullscreen video
    windowrule {
        name = browser-idleinhibit
        idle_inhibit = fullscreen
        match:class = ^(firefox|microsoft-edge)$
    }

    # Picture-in-Picture
    windowrule {
        name = pip-float
        float = on
        match:title = ^(Picture-in-Picture)$
    }
    windowrule {
        name = pip-pin
        pin = on
        match:title = ^(Picture-in-Picture)$
    }
    windowrule {
        name = pip-size
        size = 480 270
        match:title = ^(Picture-in-Picture)$
    }
    windowrule {
        name = pip-move
        move = (monitor_w*0.72) (monitor_h*0.07)
        match:title = ^(Picture-in-Picture)$
    }
    windowrule {
        name = pip-opacity
        opacity = 0.95 0.75
        match:title = ^(Picture-in-Picture)$
    }
    windowrule {
        name = pip-keepaspectratio
        keep_aspect_ratio = on
        match:title = ^(Picture-in-Picture)$
    }
    windowrule {
        name = pip-nodim
        no_dim = on
        match:title = ^(Picture-in-Picture)$
    }

    # Dropdown terminal scratchpad
    windowrule {
        name = dropdown-workspace
        workspace = special:dropdown
        match:class = ^(dropdown-terminal)$
    }
    windowrule {
        name = dropdown-float
        float = on
        match:class = ^(dropdown-terminal)$
    }
    windowrule {
        name = dropdown-size
        size = 98% 45%
        match:class = ^(dropdown-terminal)$
    }
    windowrule {
        name = dropdown-move
        move = 1% 2%
        match:class = ^(dropdown-terminal)$
    }

    # Lazygit scratchpad
    windowrule {
        name = lazygit-workspace
        workspace = special:lazygit
        match:class = ^(lazygit-scratch)$
    }
    windowrule {
        name = lazygit-float
        float = on
        match:class = ^(lazygit-scratch)$
    }
    windowrule {
        name = lazygit-size
        size = 85% 80%
        match:class = ^(lazygit-scratch)$
    }
    windowrule {
        name = lazygit-center
        center = on
        match:class = ^(lazygit-scratch)$
    }

    # Btop scratchpad
    windowrule {
        name = btop-workspace
        workspace = special:btop
        match:class = ^(btop-scratch)$
    }
    windowrule {
        name = btop-float
        float = on
        match:class = ^(btop-scratch)$
    }
    windowrule {
        name = btop-size
        size = 75% 70%
        match:class = ^(btop-scratch)$
    }
    windowrule {
        name = btop-center
        center = on
        match:class = ^(btop-scratch)$
    }
  '';

  waybarConfig = builtins.toJSON [{
    layer = "top";
    position = "top";
    height = 38;
    "margin-top" = 8;
    "margin-left" = 8;
    "margin-right" = 8;
    spacing = 0;
    modules-left = [ "hyprland/workspaces" "hyprland/window" ];
    modules-center = [ "clock" ];
    modules-right = [ "temperature" "cpu" "memory" "network" "pulseaudio" "tray" "custom/notification" ];

    "hyprland/workspaces" = {
      format = "{name}";
      on-click = "activate";
      sort-by-number = true;
    };
    "hyprland/window" = {
      max-length = 40;
      separate-outputs = true;
    };
    clock = {
      format = "󰥔  {:%a %b %d  %I:%M %p}";
      tooltip-format = "<tt>{calendar}</tt>";
    };
    cpu = {
      format = "󰻠  {usage}%";
      interval = 2;
      tooltip = false;
    };
    memory = {
      format = "󰍛  {percentage}%";
      interval = 2;
      tooltip-format = "{used:0.1f}G / {total:0.1f}G";
    };
    temperature = {
      format = "  {temperatureC}°C";
      critical-threshold = 80;
      format-critical = "  {temperatureC}°C";
      tooltip = false;
    };
    pulseaudio = {
      format = "󰕾  {volume}%";
      format-muted = "󰖁  Muted";
      on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      scroll-step = 5;
      tooltip = false;
    };
    network = {
      format-wifi = "󰤨  {essid}";
      format-ethernet = "󰈀  Wired";
      format-disconnected = "󰤭  Offline";
      tooltip-format-wifi = "{signalStrength}% — {ipaddr}";
      tooltip-format-ethernet = "{ipaddr}";
      on-click = "networkmanager_dmenu";
    };
    tray = {
      spacing = 8;
      icon-size = 16;
    };
    "custom/notification" = {
      tooltip = false;
      format = "{icon}";
      format-icons = {
        notification = "󰂚";
        none = "󰂜";
        dnd-notification = "󰂛";
        dnd-none = "󰪑";
        inhibited-notification = "󰂚";
        inhibited-none = "󰂜";
        dnd-inhibited-notification = "󰂛";
        dnd-inhibited-none = "󰪑";
      };
      return-type = "json";
      exec-if = "which swaync-client";
      exec = "swaync-client -swb";
      on-click = "swaync-client -t -sw";
      on-click-right = "swaync-client -d -sw";
      escape = true;
    };
  }];

  waybarStyle = ''
    * {
      font-family: "JetBrainsMono Nerd Font", monospace;
      font-size: 13px;
      border: none;
      border-radius: 0;
      min-height: 0;
      padding: 0;
      margin: 0;
    }

    window#waybar {
      background: transparent;
      color: #cdd6f4;
    }

    /* Floating frosted-glass pill containers */
    .modules-left,
    .modules-center,
    .modules-right {
      background: rgba(17, 17, 27, 0.72);
      border: 1px solid rgba(180, 190, 254, 0.18);
      border-radius: 14px;
      margin: 0 4px;
      padding: 0 4px;
    }

    /* Workspaces */
    #workspaces {
      margin: 0 2px;
    }

    #workspaces button {
      padding: 2px 12px;
      color: #6c7086;
      border-radius: 10px;
      margin: 4px 2px;
      background: transparent;
      border: 1px solid transparent;
      transition: all 0.15s ease;
    }

    #workspaces button.active {
      color: #89b4fa;
      background: rgba(137, 180, 250, 0.15);
      border: 1px solid rgba(137, 180, 250, 0.4);
    }

    #workspaces button:hover {
      color: #b4befe;
      background: rgba(180, 190, 254, 0.1);
      border: 1px solid rgba(180, 190, 254, 0.2);
    }

    #workspaces button.urgent {
      color: #f38ba8;
      background: rgba(243, 139, 168, 0.1);
      border: 1px solid rgba(243, 139, 168, 0.4);
    }

    #window {
      color: #a6adc8;
      padding: 0 12px;
      font-style: italic;
      font-size: 12px;
    }

    #clock {
      color: #cba6f7;
      font-weight: bold;
      padding: 0 16px;
      letter-spacing: 0.5px;
    }

    #cpu {
      color: #89b4fa;
      padding: 0 10px;
    }

    #memory {
      color: #a6e3a1;
      padding: 0 10px;
    }

    #temperature {
      color: #fab387;
      padding: 0 10px;
    }

    #temperature.critical {
      color: #f38ba8;
    }

    #pulseaudio {
      color: #f9e2af;
      padding: 0 10px;
    }

    #pulseaudio.muted {
      color: #585b70;
    }

    #network {
      color: #94e2d5;
      padding: 0 10px;
    }

    #network.disconnected {
      color: #f38ba8;
    }

    #tray {
      padding: 0 8px;
    }

    #tray > .passive {
      -gtk-icon-effect: dim;
    }

    #tray > .needs-attention {
      -gtk-icon-effect: highlight;
    }

    #custom-notification {
      color: #89b4fa;
      padding: 0 10px;
    }

    /* Hover effects for all modules */
    #cpu:hover,
    #memory:hover,
    #temperature:hover,
    #pulseaudio:hover,
    #network:hover,
    #custom-notification:hover {
      background: rgba(137, 180, 250, 0.08);
      border-radius: 8px;
    }
  '';

  hyprlockConfig = ''
    background {
        monitor =
        path = screenshot
        blur_passes = 4
        blur_size = 10
        noise = 0.02
        brightness = 0.6
    }

    # Decorative accent bar behind the clock
    shape {
        monitor =
        size = 400, 180
        rounding = 20
        color = rgba(17, 17, 27, 0.55)
        border_size = 1
        border_color = rgba(180, 190, 254, 0.15)
        halign = center
        valign = center
        position = 0, 80
        shadow_passes = 2
        shadow_size = 8
        shadow_color = rgba(0, 0, 0, 0.4)
    }

    # Profile image
    image {
        monitor =
        path = ~/wallpapers/profile.png
        size = 120
        rounding = -1
        border_size = 3
        border_color = rgb(cba6f7) rgb(89b4fa) 45deg
        halign = center
        valign = center
        position = 0, 240
        shadow_passes = 2
        shadow_size = 6
        shadow_color = rgba(0, 0, 0, 0.5)
    }

    # Greeting
    label {
        monitor =
        text = Hey, $USER
        color = rgba(205, 214, 244, 0.9)
        font_size = 18
        font_family = JetBrainsMono Nerd Font
        halign = center
        valign = center
        position = 0, 160
    }

    # Time
    label {
        monitor =
        text = cmd[update:1000] echo "<b>$(date +'%H:%M')</b>"
        color = rgba(cdd6f4ff)
        font_size = 72
        font_family = JetBrainsMono Nerd Font Bold
        halign = center
        valign = center
        position = 0, 100
        shadow_passes = 2
        shadow_size = 4
        shadow_color = rgba(0, 0, 0, 0.5)
    }

    # Date
    label {
        monitor =
        text = cmd[update:60000] echo "$(date +'%A, %B %d')"
        color = rgba(166, 173, 200, 0.9)
        font_size = 18
        font_family = JetBrainsMono Nerd Font
        halign = center
        valign = center
        position = 0, 30
    }

    # Uptime
    label {
        monitor =
        text = cmd[update:60000] echo "󰅐  $(uptime -p | sed 's/up //')"
        color = rgba(108, 112, 134, 0.8)
        font_size = 12
        font_family = JetBrainsMono Nerd Font
        halign = center
        valign = center
        position = 0, -10
    }

    # Decorative accent bar behind input
    shape {
        monitor =
        size = 340, 70
        rounding = 18
        color = rgba(17, 17, 27, 0.45)
        border_size = 0
        halign = center
        valign = center
        position = 0, -80
        zindex = -1
    }

    # Password input
    input-field {
        monitor =
        size = 300, 50
        outline_thickness = 2
        dots_size = 0.25
        dots_spacing = 0.15
        outer_color = rgb(89b4fa)
        inner_color = rgba(30, 30, 46, 0.8)
        font_color = rgb(cdd6f4)
        fade_on_empty = true
        placeholder_text = <i>  Password...</i>
        halign = center
        valign = center
        position = 0, -80
        shadow_passes = 2
        shadow_size = 4
        shadow_color = rgba(0, 0, 0, 0.3)
    }
  '';

  hypridleConfig = ''
    general {
        lock_cmd = pidof hyprlock || hyprlock
        before_sleep_cmd = loginctl lock-session
        after_sleep_cmd = hyprctl dispatch dpms on
    }

    listener {
        timeout = 300
        on-timeout = hyprlock
    }

    listener {
        timeout = 600
        on-timeout = hyprctl dispatch dpms off
        on-resume = hyprctl dispatch dpms on
    }
  '';

  # swww replaces hyprpaper — no config file needed, it's controlled via CLI

  swayncConfig = builtins.toJSON {
    positionX = "right";
    positionY = "top";
    layer = "overlay";
    control-center-layer = "top";
    layer-shell = true;
    cssPriority = "application";
    control-center-margin-top = 10;
    control-center-margin-bottom = 10;
    control-center-margin-right = 10;
    control-center-width = 380;
    notification-2fa-action = true;
    notification-inline-replies = true;
    notification-icon-size = 48;
    notification-body-image-height = 100;
    notification-body-image-width = 200;
    timeout = 5;
    timeout-low = 3;
    timeout-critical = 0;
    fit-to-screen = true;
    control-center-exclusive-zone = false;
    notification-window-width = 360;
    keyboard-shortcuts = true;
    image-visibility = "when-available";
    transition-time = 200;
    hide-on-clear = false;
    hide-on-action = true;
    script-fail-notify = true;
    widgets = [ "inhibitors" "title" "dnd" "notifications" ];
    widget-config = {
      inhibitors = {
        text = "Inhibitors";
        button-text = "Clear All";
        clear-all-button = true;
      };
      title = {
        text = "Notifications";
        clear-all-button = true;
        button-text = "Clear All";
      };
      dnd = {
        text = "Do Not Disturb";
      };
    };
  };

  swayncStyle = ''
    * {
      font-family: "JetBrainsMono Nerd Font", monospace;
      font-size: 13px;
    }

    .control-center {
      background: rgba(17, 17, 27, 0.82);
      border: 1px solid rgba(180, 190, 254, 0.18);
      border-radius: 16px;
      color: #cdd6f4;
    }

    .notification-row {
      outline: none;
    }

    .notification {
      background: rgba(30, 30, 46, 0.75);
      border: 1px solid rgba(137, 180, 250, 0.2);
      border-radius: 14px;
      margin: 6px 12px;
      padding: 0;
    }

    .notification-content {
      padding: 10px 14px;
    }

    .notification.critical {
      border-color: rgba(243, 139, 168, 0.6);
    }

    .notification.low {
      border-color: rgba(108, 112, 134, 0.4);
    }

    .close-button {
      background: rgba(243, 139, 168, 0.2);
      border-radius: 50%;
      color: #f38ba8;
      min-width: 24px;
      min-height: 24px;
      margin: 4px;
    }

    .close-button:hover {
      background: rgba(243, 139, 168, 0.4);
    }

    .summary {
      color: #cdd6f4;
      font-weight: bold;
    }

    .body {
      color: #a6adc8;
    }

    .time {
      color: #6c7086;
      font-size: 11px;
    }

    .control-center-list {
      background: transparent;
    }

    .widget-title {
      color: #cba6f7;
      font-weight: bold;
      padding: 8px 16px;
    }

    .widget-title > button {
      background: rgba(203, 166, 247, 0.15);
      border: 1px solid rgba(203, 166, 247, 0.3);
      border-radius: 10px;
      color: #cba6f7;
      padding: 4px 14px;
    }

    .widget-title > button:hover {
      background: rgba(203, 166, 247, 0.3);
    }

    .widget-dnd {
      color: #cdd6f4;
      padding: 4px 16px;
    }

    .widget-dnd > switch {
      background: rgba(108, 112, 134, 0.3);
      border-radius: 12px;
    }

    .widget-dnd > switch:checked {
      background: rgba(137, 180, 250, 0.4);
    }

    .widget-dnd > switch slider {
      background: #cdd6f4;
      border-radius: 50%;
    }

    .floating-notifications {
      background: transparent;
    }
  '';

  swayncConfigFile = pkgs.writeText "swaync-config.json" swayncConfig;
  swayncStyleFile = pkgs.writeText "swaync-style.css" swayncStyle;

  nmDmenuConfig = ''
    [dmenu]
    dmenu_command = rofi -dmenu -p Network

    [editor]
    terminal = ghostty
    gui_if_available = False
  '';

  rofiConfig = ''
    configuration {
      modi: "drun,run,window";
      show-icons: true;
      icon-theme: "Papirus-Dark";
      display-drun: "Apps";
      display-run: "Run";
      display-window: "Windows";
      drun-display-format: "{name}";
      font: "JetBrainsMono Nerd Font 13";
    }

    @theme "/dev/null"

    * {
      bg:           rgba(17, 17, 27, 0.82);
      bg-alt:       rgba(30, 30, 46, 0.75);
      fg:           #cdd6f4;
      fg-alt:       #a6adc8;
      accent:       #89b4fa;
      accent-alt:   #cba6f7;
      border-col:   rgba(180, 190, 254, 0.18);
      selected:     rgba(137, 180, 250, 0.15);
      urgent:       #f38ba8;
    }

    window {
      width: 600px;
      transparency: "real";
      background-color: @bg;
      border: 1px solid;
      border-color: @border-col;
      border-radius: 16px;
      padding: 0;
    }

    mainbox {
      background-color: transparent;
      children: [inputbar, listview];
      spacing: 0;
      padding: 8px;
    }

    inputbar {
      background-color: @bg-alt;
      border: 1px solid;
      border-color: rgba(137, 180, 250, 0.25);
      border-radius: 12px;
      padding: 10px 14px;
      margin: 6px;
      children: [prompt, entry];
      spacing: 10px;
    }

    prompt {
      background-color: transparent;
      text-color: @accent;
      font: "JetBrainsMono Nerd Font Bold 13";
    }

    entry {
      background-color: transparent;
      text-color: @fg;
      placeholder: "Search...";
      placeholder-color: #585b70;
    }

    listview {
      background-color: transparent;
      columns: 1;
      lines: 8;
      spacing: 4px;
      padding: 4px 6px;
      fixed-height: true;
      scrollbar: false;
    }

    element {
      background-color: transparent;
      text-color: @fg;
      padding: 8px 12px;
      border-radius: 10px;
      border: 1px solid;
      border-color: transparent;
    }

    element selected {
      background-color: @selected;
      text-color: @accent;
      border-color: rgba(137, 180, 250, 0.35);
    }

    element-text {
      background-color: transparent;
      text-color: inherit;
      highlight: bold underline;
    }

    element-icon {
      background-color: transparent;
      size: 24px;
      margin: 0 10px 0 0;
    }
  '';

  nmDmenuConfigFile = pkgs.writeText "networkmanager-dmenu.ini" nmDmenuConfig;
  waybarConfigFile = pkgs.writeText "waybar-config" waybarConfig;
  waybarStyleFile = pkgs.writeText "waybar-style.css" waybarStyle;
  hyprlandConfigFile = pkgs.writeText "hyprland.conf" hyprlandConfig;
  hyprlockConfigFile = pkgs.writeText "hyprlock.conf" hyprlockConfig;
  hypridleConfigFile = pkgs.writeText "hypridle.conf" hypridleConfig;
  rofiConfigFile = pkgs.writeText "rofi-config.rasi" rofiConfig;
in
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # Hyprland ecosystem packages
  users.users.jboe.packages = with pkgs; [
    waybar
    rofi
    swaynotificationcenter
    libnotify
    grimblast
    swww
    hyprlock
    hypridle
    hyprpolkitagent
    wl-clipboard
    cliphist
    pavucontrol
    hyprpicker
    hyprsunset
    satty
    networkmanagerapplet
    networkmanager_dmenu
    waypaper
    wf-recorder
    mangohud
    slurp
  ];

  # Deploy configs via activation script (same pattern as ghostty.nix)
  system.activationScripts.hyprlandConfig = ''
    hyprDir="/home/jboe/.config/hypr"
    waybarDir="/home/jboe/.config/waybar"
    rofiDir="/home/jboe/.config/rofi"
    swayncDir="/home/jboe/.config/swaync"
    nmDmenuDir="/home/jboe/.config/networkmanager-dmenu"

    mkdir -p "$hyprDir" "$waybarDir" "$rofiDir" "$swayncDir" "$nmDmenuDir"

    ln -sf ${hyprlandConfigFile} "$hyprDir/hyprland.conf"
    ln -sf ${hyprlockConfigFile} "$hyprDir/hyprlock.conf"
    ln -sf ${hypridleConfigFile} "$hyprDir/hypridle.conf"

    ln -sf ${waybarConfigFile} "$waybarDir/config"
    ln -sf ${waybarStyleFile} "$waybarDir/style.css"

    ln -sf ${rofiConfigFile} "$rofiDir/config.rasi"

    ln -sf ${swayncConfigFile} "$swayncDir/config.json"
    ln -sf ${swayncStyleFile} "$swayncDir/style.css"

    ln -sf ${nmDmenuConfigFile} "$nmDmenuDir/config.ini"

    chown -h jboe:users "$hyprDir/hyprland.conf" "$hyprDir/hyprlock.conf" "$hyprDir/hypridle.conf"
    chown -h jboe:users "$waybarDir/config" "$waybarDir/style.css"
    chown -h jboe:users "$rofiDir/config.rasi"
    chown -h jboe:users "$swayncDir/config.json" "$swayncDir/style.css"
    chown -h jboe:users "$nmDmenuDir/config.ini"
  '';
}
