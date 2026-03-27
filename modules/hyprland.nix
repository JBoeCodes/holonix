{ pkgs, ... }:

let
  hyprlandConfig = ''
    ################
    ### MONITORS ###
    ################
    monitor = , preferred, auto, 1

    #################
    ### AUTOSTART ###
    #################
    exec-once = waybar
    exec-once = mako
    exec-once = hyprpaper
    exec-once = wl-paste --type text --watch cliphist store
    exec-once = wl-paste --type image --watch cliphist store
    exec-once = hyprpolkitagent
    exec-once = hypridle
    exec-once = hyprsunset -t 4500
    exec-once = nm-applet --indicator
    exec-once = waypaper --restore

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
        col.active_border = rgba(89b4faee) rgba(cba6f7ee) 45deg
        col.inactive_border = rgba(585b70aa)
        layout = dwindle
    }

    decoration {
        rounding = 10
        active_opacity = 1.0
        inactive_opacity = 0.92

        shadow {
            enabled = true
            range = 8
            render_power = 2
            color = rgba(1a1a2eee)
        }

        blur {
            enabled = true
            size = 8
            passes = 4
            new_optimizations = true
        }

        dim_inactive = true
        dim_strength = 0.05
    }

    animations {
        enabled = true
        bezier = ease, 0.25, 0.1, 0.25, 1.0
        bezier = overshot, 0.05, 0.9, 0.1, 1.05
        animation = windows, 1, 5, overshot, slide
        animation = windowsOut, 1, 5, ease, slide
        animation = fade, 1, 4, ease
        animation = workspaces, 1, 4, overshot, slidevert
        animation = border, 1, 5, ease
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
    bind = $mod, Space, exec, wofi --show drun
    bind = $mod, R, exec, wofi --show run

    # Clipboard history
    bind = $mod SHIFT, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy

    # Screenshot (matching your GNOME Super+Shift+S)
    bind = $mod SHIFT, S, exec, grimblast --notify copy area

    # Annotated screenshot
    bind = $mod SHIFT, A, exec, grimblast save area - | satty --filename -

    # Color picker
    bind = $mod SHIFT, C, exec, hyprpicker -a

    # Wallpaper picker
    bind = $mod SHIFT, W, exec, waypaper

    # Scratchpad
    bind = $mod, grave, togglespecialworkspace, scratchpad
    bind = $mod SHIFT, grave, movetoworkspace, special:scratchpad

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
    layerrule = blur, waybar
    layerrule = ignorezero, waybar
    layerrule = blur, wofi
    layerrule = ignorezero, wofi
    layerrule = blur, notifications
    layerrule = ignorezero, notifications

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
    modules-right = [ "temperature" "cpu" "memory" "network" "pulseaudio" "tray" ];

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
    };
    tray = {
      spacing = 8;
      icon-size = 16;
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
  '';

  hyprlockConfig = ''
    background {
        monitor =
        path = screenshot
        blur_passes = 3
        blur_size = 8
    }

    label {
        monitor =
        text = cmd[update:1000] echo "<b>$(date +'%H:%M')</b>"
        color = rgba(cdd6f4ff)
        font_size = 80
        font_family = JetBrainsMono Nerd Font Bold
        halign = center
        valign = center
        position = 0, 100
    }

    label {
        monitor =
        text = cmd[update:60000] echo "$(date +'%A, %B %d')"
        color = rgba(a6adc8ff)
        font_size = 20
        font_family = JetBrainsMono Nerd Font
        halign = center
        valign = center
        position = 0, 20
    }

    input-field {
        monitor =
        size = 300, 50
        outline_thickness = 2
        dots_size = 0.25
        dots_spacing = 0.15
        outer_color = rgb(89b4fa)
        inner_color = rgb(1e1e2e)
        font_color = rgb(cdd6f4)
        fade_on_empty = true
        placeholder_text = <i>Password...</i>
        halign = center
        valign = center
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

  hyprpaperConfig = ''
    preload = ~/wallpapers/wallpaper.png
    wallpaper = , ~/wallpapers/wallpaper.png
    splash = false
  '';

  makoConfig = ''
    sort=-time
    layer=overlay
    anchor=top-right
    margin=12
    padding=14,16
    icons=1
    max-icon-size=48
    default-timeout=5000
    font=JetBrainsMono Nerd Font 12
    background-color=#11111bcc
    text-color=#cdd6f4
    border-color=#b4befec0
    border-radius=14
    border-size=1
    width=340
    format=<b>%s</b>\n%b

    [urgency=low]
    border-color=#6c708680
    background-color=#11111ba0
    default-timeout=3000

    [urgency=normal]
    border-color=#89b4fac0
    background-color=#11111bcc

    [urgency=high]
    border-color=#f38ba8cc
    background-color=#11111be0
    default-timeout=0
  '';

  makoConfigFile = pkgs.writeText "mako-config" makoConfig;

  wofiConfig = ''
    width=600
    height=400
    prompt=Search...
    fuzzy=true
    insensitive=true
    allow_markup=true
    always_parse_args=true
    show_all=false
    print_command=true
    layer=overlay
  '';

  wofiStyle = ''
    * {
      font-family: "JetBrainsMono Nerd Font", monospace;
      font-size: 14px;
    }

    window {
      background-color: rgba(17, 17, 27, 0.78);
      border: 1px solid rgba(180, 190, 254, 0.2);
      border-radius: 16px;
    }

    #input {
      background-color: rgba(30, 30, 46, 0.6);
      color: #cdd6f4;
      border: 1px solid rgba(137, 180, 250, 0.25);
      border-radius: 10px;
      padding: 10px 14px;
      margin: 10px;
      outline: none;
      caret-color: #89b4fa;
    }

    #input:focus {
      border-color: rgba(137, 180, 250, 0.6);
      background-color: rgba(30, 30, 46, 0.75);
    }

    #outer-box {
      padding: 4px;
    }

    #inner-box {
      margin: 0 10px 10px 10px;
    }

    #scroll {
      background-color: transparent;
    }

    #entry {
      border-radius: 10px;
      padding: 8px 10px;
      margin: 2px 0;
      border: 1px solid transparent;
    }

    #entry:selected {
      background-color: rgba(137, 180, 250, 0.12);
      border: 1px solid rgba(137, 180, 250, 0.35);
    }

    #text {
      color: #cdd6f4;
      padding: 0 6px;
    }

    #entry:selected #text {
      color: #89b4fa;
    }

    #img {
      margin-right: 10px;
    }
  '';

  waybarConfigFile = pkgs.writeText "waybar-config" waybarConfig;
  waybarStyleFile = pkgs.writeText "waybar-style.css" waybarStyle;
  hyprlandConfigFile = pkgs.writeText "hyprland.conf" hyprlandConfig;
  hyprlockConfigFile = pkgs.writeText "hyprlock.conf" hyprlockConfig;
  hypridleConfigFile = pkgs.writeText "hypridle.conf" hypridleConfig;
  hyprpaperConfigFile = pkgs.writeText "hyprpaper.conf" hyprpaperConfig;
  wofiConfigFile = pkgs.writeText "wofi-config" wofiConfig;
  wofiStyleFile = pkgs.writeText "wofi-style.css" wofiStyle;
in
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # Hyprland ecosystem packages
  users.users.jboe.packages = with pkgs; [
    waybar
    wofi
    mako
    libnotify
    grimblast
    hyprpaper
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
    waypaper
  ];

  # Deploy configs via activation script (same pattern as ghostty.nix)
  system.activationScripts.hyprlandConfig = ''
    hyprDir="/home/jboe/.config/hypr"
    waybarDir="/home/jboe/.config/waybar"
    makoDir="/home/jboe/.config/mako"
    wofiDir="/home/jboe/.config/wofi"

    mkdir -p "$hyprDir" "$waybarDir" "$makoDir" "$wofiDir"

    ln -sf ${hyprlandConfigFile} "$hyprDir/hyprland.conf"
    ln -sf ${hyprlockConfigFile} "$hyprDir/hyprlock.conf"
    ln -sf ${hypridleConfigFile} "$hyprDir/hypridle.conf"
    ln -sf ${hyprpaperConfigFile} "$hyprDir/hyprpaper.conf"

    ln -sf ${waybarConfigFile} "$waybarDir/config"
    ln -sf ${waybarStyleFile} "$waybarDir/style.css"

    ln -sf ${wofiConfigFile} "$wofiDir/config"
    ln -sf ${wofiStyleFile} "$wofiDir/style.css"

    ln -sf ${makoConfigFile} "$makoDir/config"

    chown -h jboe:users "$hyprDir/hyprland.conf" "$hyprDir/hyprlock.conf" "$hyprDir/hypridle.conf" "$hyprDir/hyprpaper.conf"
    chown -h jboe:users "$waybarDir/config" "$waybarDir/style.css"
    chown -h jboe:users "$wofiDir/config" "$wofiDir/style.css"
    chown -h jboe:users "$makoDir/config"
  '';
}
