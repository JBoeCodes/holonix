{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Variables
      "$mod" = "SUPER";
      "$term" = "kitty";
      "$files" = "thunar";
      "$scriptsDir" = "$HOME/.config/hypr/scripts";

      # Environment variables
      env = [
        "GDK_BACKEND,wayland,x11,*"
        "QT_QPA_PLATFORM,wayland;xcb"
        "CLUTTER_BACKEND,wayland"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_QPA_PLATFORMTHEME,qt6ct"
        "QT_STYLE_OVERRIDE,kvantum"
        "QT_QUICK_CONTROLS_STYLE,org.hyprland.style"
        "GDK_SCALE,1"
        "QT_SCALE_FACTOR,1"
        "MOZ_ENABLE_WAYLAND,1"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
      ];

      # Autostart
      "exec-once" = [
        "awww-daemon"
        "nm-applet --indicator"
        "swaync"
        "waybar"
        "hypridle"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "systemctl --user start hyprpolkitagent"
        "$scriptsDir/Dropterminal.sh $term &"
      ];

      # General
      general = {
        border_size = 2;
        gaps_in = 2;
        gaps_out = 4;
        resize_on_border = true;
        layout = "dwindle";
      };

      # Decoration
      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 0.9;
        fullscreen_opacity = 1.0;
        dim_inactive = true;
        dim_strength = 0.1;
        dim_special = 0.8;
        shadow = {
          enabled = true;
          range = 3;
          render_power = 1;
        };
        blur = {
          enabled = true;
          size = 6;
          passes = 3;
          new_optimizations = true;
          xray = true;
          ignore_opacity = true;
          special = true;
          popups = true;
        };
      };

      # Animations
      animations = {
        enabled = true;
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
          "overshot, 0.05, 0.9, 0.1, 1.05"
          "smoothOut, 0.5, 0, 0.99, 0.99"
          "smoothIn, 0.5, -0.5, 0.68, 1.5"
        ];
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 5, winIn, slide"
          "windowsOut, 1, 3, smoothOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 180, liner, loop"
          "fade, 1, 3, smoothOut"
          "workspaces, 1, 5, overshot"
          "workspacesIn, 1, 5, winIn, slide"
          "workspacesOut, 1, 5, winOut, slide"
        ];
      };

      # Input
      input = {
        kb_layout = "us";
        kb_options = "altwin:swap_alt_win";
        repeat_rate = 50;
        repeat_delay = 300;
        sensitivity = 0;
        numlock_by_default = true;
        follow_mouse = 1;
        float_switch_override_focus = false;
        touchpad = {
          disable_while_typing = true;
          natural_scroll = true;
          tap-to-click = true;
        };
      };

      # Dwindle layout
      dwindle = {
        preserve_split = true;
        smart_resizing = true;
        use_active_for_splits = true;
        special_scale_factor = 0.8;
      };

      # Master layout
      master = {
        new_status = "slave";
        orientation = "left";
        mfact = 0.55;
        smart_resizing = true;
        drop_at_cursor = true;
      };

      # Misc
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        vfr = true;
        vrr = 2;
        mouse_move_enables_dpms = true;
        focus_on_activate = false;
        initial_workspace_tracking = 0;
        middle_click_paste = false;
        enable_anr_dialog = true;
        anr_missed_pings = 15;
        allow_session_lock_restore = true;
        on_focus_under_fullscreen = 1;
      };

      # Cursor
      cursor = {
        no_hardware_cursors = true;
        sync_gsettings_theme = true;
        enable_hyprcursor = true;
        warp_on_change_workspace = 2;
        no_warps = true;
        hide_on_key_press = true;
      };

      # XWayland
      xwayland = {
        force_zero_scaling = true;
      };

      # Binds
      binds = {
        workspace_back_and_forth = true;
        allow_workspace_cycles = true;
      };

      # Keybinds (bindd = described binds)
      bindd = [
        # Standard
        "$mod, D, app launcher, exec, pkill rofi || true && rofi -show drun -modi drun,filebrowser,run,window"
        "$mod, B, open browser, exec, xdg-open https://"
        "$mod, Return, open terminal, exec, $term"
        "$mod, E, file manager, exec, $files"
        "$mod, O, open outlook, exec, xdg-open https://outlook.office.com"

        # Features
        "$mod, T, theme switcher, exec, $scriptsDir/ThemeChanger.sh"
        "$mod, slash, help / cheat sheet, exec, $scriptsDir/KeyHints.sh"
        "$mod ALT, R, refresh bar, exec, $scriptsDir/Refresh.sh"
        "$mod ALT, E, emoji menu, exec, $scriptsDir/RofiEmoji.sh"
        "$mod, S, web search, exec, $scriptsDir/RofiSearch.sh"
        "$mod CTRL, S, window switcher, exec, rofi -show window"
        "$mod ALT, O, toggle blur, exec, $scriptsDir/ChangeBlur.sh"
        "$mod SHIFT, G, toggle game mode, exec, $scriptsDir/GameMode.sh"
        "$mod ALT, L, toggle layouts, exec, $scriptsDir/ChangeLayout.sh toggle"
        "$mod ALT, V, clipboard manager, exec, $scriptsDir/ClipManager.sh"
        "$mod, N, toggle night light, exec, $scriptsDir/Hyprsunset.sh toggle"
        "$mod SHIFT, F, fullscreen, fullscreen"
        "$mod CTRL, F, maximize, fullscreen, 1"
        "$mod, SPACE, toggle float, togglefloating,"
        "$mod SHIFT, Return, dropdown terminal, exec, $scriptsDir/Dropterminal.sh $term"
        ''$mod, W, random wallpaper, exec, awww img "$(find ~/Pictures/wallpapers -type f | shuf -n 1)" --transition-type grow --transition-duration 0.5 --transition-fps 60''
        "$mod SHIFT, N, notification panel, exec, swaync-client -t -sw"

        # System
        "CTRL ALT, Delete, exit Hyprland, exec, hyprctl dispatch exit 0"
        "$mod, Q, close window, killactive,"
        "CTRL ALT, L, lock screen, exec, loginctl lock-session"
        "CTRL ALT, P, power menu, exec, wlogout -b 4"

        # Vim-style focus
        "$mod, H, focus left, movefocus, l"
        "$mod, J, focus down, movefocus, d"
        "$mod, K, focus up, movefocus, u"
        "$mod, L, focus right, movefocus, r"

        # Vim-style move
        "$mod CTRL, H, move window left, movewindow, l"
        "$mod CTRL, J, move window down, movewindow, d"
        "$mod CTRL, K, move window up, movewindow, u"
        "$mod CTRL, L, move window right, movewindow, r"

        # Arrow key focus
        "$mod, left, focus left, movefocus, l"
        "$mod, right, focus right, movefocus, r"
        "$mod, up, focus up, movefocus, u"
        "$mod, down, focus down, movefocus, d"

        # Arrow key move
        "$mod CTRL, left, move left, movewindow, l"
        "$mod CTRL, right, move right, movewindow, r"
        "$mod CTRL, up, move up, movewindow, u"
        "$mod CTRL, down, move down, movewindow, d"

        # Arrow key swap
        "$mod ALT, left, swap left, swapwindow, l"
        "$mod ALT, right, swap right, swapwindow, r"
        "$mod ALT, up, swap up, swapwindow, u"
        "$mod ALT, down, swap down, swapwindow, d"

        # Dwindle / Layout
        "$mod, I, toggle split, layoutmsg, togglesplit"
        "$mod, P, toggle pseudo, pseudo,"
        "$mod, G, toggle group, togglegroup"
        "$mod, Tab, next in group, changegroupactive, f"
        "$mod SHIFT, Tab, prev in group, changegroupactive, b"
        "$mod ALT, 1, layout dwindle, exec, $scriptsDir/ChangeLayout.sh dwindle"
        "$mod ALT, 2, layout master, exec, $scriptsDir/ChangeLayout.sh master"
        "$mod ALT, 3, layout scrolling, exec, $scriptsDir/ChangeLayout.sh scrolling"
        "$mod ALT, 4, layout monocle, exec, $scriptsDir/ChangeLayout.sh monocle"

        # Workspaces
        "$mod, code:10, workspace 1, workspace, 1"
        "$mod, code:11, workspace 2, workspace, 2"
        "$mod, code:12, workspace 3, workspace, 3"
        "$mod, code:13, workspace 4, workspace, 4"
        "$mod, code:14, workspace 5, workspace, 5"
        "$mod, code:15, workspace 6, workspace, 6"
        "$mod, code:16, workspace 7, workspace, 7"
        "$mod, code:17, workspace 8, workspace, 8"
        "$mod, code:18, workspace 9, workspace, 9"
        "$mod, code:19, workspace 10, workspace, 10"

        # Move to workspace
        "$mod SHIFT, code:10, move to ws 1, movetoworkspace, 1"
        "$mod SHIFT, code:11, move to ws 2, movetoworkspace, 2"
        "$mod SHIFT, code:12, move to ws 3, movetoworkspace, 3"
        "$mod SHIFT, code:13, move to ws 4, movetoworkspace, 4"
        "$mod SHIFT, code:14, move to ws 5, movetoworkspace, 5"
        "$mod SHIFT, code:15, move to ws 6, movetoworkspace, 6"
        "$mod SHIFT, code:16, move to ws 7, movetoworkspace, 7"
        "$mod SHIFT, code:17, move to ws 8, movetoworkspace, 8"
        "$mod SHIFT, code:18, move to ws 9, movetoworkspace, 9"
        "$mod SHIFT, code:19, move to ws 10, movetoworkspace, 10"

        # Move to workspace (silent)
        "$mod CTRL, code:10, move silent to ws 1, movetoworkspacesilent, 1"
        "$mod CTRL, code:11, move silent to ws 2, movetoworkspacesilent, 2"
        "$mod CTRL, code:12, move silent to ws 3, movetoworkspacesilent, 3"
        "$mod CTRL, code:13, move silent to ws 4, movetoworkspacesilent, 4"
        "$mod CTRL, code:14, move silent to ws 5, movetoworkspacesilent, 5"
        "$mod CTRL, code:15, move silent to ws 6, movetoworkspacesilent, 6"
        "$mod CTRL, code:16, move silent to ws 7, movetoworkspacesilent, 7"
        "$mod CTRL, code:17, move silent to ws 8, movetoworkspacesilent, 8"
        "$mod CTRL, code:18, move silent to ws 9, movetoworkspacesilent, 9"
        "$mod CTRL, code:19, move silent to ws 10, movetoworkspacesilent, 10"

        # Workspace navigation
        "$mod, period, next workspace, workspace, e+1"
        "$mod, comma, prev workspace, workspace, e-1"
        "$mod, mouse_down, next workspace, workspace, e+1"
        "$mod, mouse_up, prev workspace, workspace, e-1"

        # Special workspace
        "$mod SHIFT, U, move to special, movetoworkspace, special"
        "$mod, U, toggle special, togglespecialworkspace,"

        # Screenshots
        "$mod, Print, screenshot now, exec, grimblast --notify copy screen"
        "$mod SHIFT, S, screenshot area, exec, grimblast --notify copy area"
        "ALT, Print, screenshot window, exec, grimblast --notify copy active"
      ];

      # Resize binds (described + repeat)
      bindde = [
        "$mod SHIFT, H, resize left, resizeactive, -50 0"
        "$mod SHIFT, J, resize down, resizeactive, 0 50"
        "$mod SHIFT, K, resize up, resizeactive, 0 -50"
        "$mod SHIFT, L, resize right, resizeactive, 50 0"
        "$mod SHIFT, left, resize left, resizeactive, -50 0"
        "$mod SHIFT, right, resize right, resizeactive, 50 0"
        "$mod SHIFT, up, resize up, resizeactive, 0 -50"
        "$mod SHIFT, down, resize down, resizeactive, 0 50"
      ];

      # Alt-tab (no description needed)
      bind = [
        "ALT, tab, cyclenext"
        "ALT, tab, bringactivetotop"
      ];

      # Media keys (volume: repeat + locked + described)
      bindeld = [
        ", xf86audioraisevolume, volume up, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", xf86audiolowervolume, volume down, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      # Media keys (toggles: locked + described)
      bindld = [
        ", xf86audiomute, toggle mute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", xf86AudioMicMute, toggle mic, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", xf86AudioPlayPause, play/pause, exec, playerctl play-pause"
        ", xf86AudioNext, next track, exec, playerctl next"
        ", xf86AudioPrev, prev track, exec, playerctl previous"
      ];

      # Mouse binds (move + described)
      bindmd = [
        "$mod, mouse:272, move window, movewindow"
        "$mod, mouse:273, resize window, resizewindow"
      ];
    };

    extraConfig = ''
      # ── Window rule tags ──────────────────────────────────────────────
      windowrule = match:class ^([Ff]irefox|org.mozilla.firefox)$, tag +browser
      windowrule = match:class ^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable))$, tag +browser
      windowrule = match:class ^(zen-alpha|zen)$, tag +browser
      windowrule = match:class ^(vivaldi)$, tag +browser
      windowrule = match:class ^(ghostty|wezterm|Alacritty|kitty)$, tag +terminal
      windowrule = match:class ^([Dd]iscord|[Vv]esktop)$, tag +im
      windowrule = match:class ^(org.telegram.desktop)$, tag +im
      windowrule = match:class ^([Ss]team)$, tag +gamestore
      windowrule = match:class ^(steam_app_\d+)$, tag +games
      windowrule = match:class ^(com.heroicgameslauncher.hgl)$, tag +gamestore
      windowrule = match:class ^([Tt]hunar|org.gnome.Nautilus)$, tag +file-manager
      windowrule = match:class ^(com.obsproject.Studio)$, tag +screenshare
      windowrule = match:class ^(codium|VSCode|code)$, tag +projects
      windowrule = match:class ^([Mm]pv|vlc)$, tag +multimedia_video
      windowrule = match:class ^(pavucontrol)$, tag +settings
      windowrule = match:class ^([Rr]ofi)$, tag +settings
      windowrule = match:class ^(nm-applet|nm-connection-editor|blueman-manager)$, tag +settings

      # ── Opacity by tag ────────────────────────────────────────────────
      windowrule = match:tag browser, opacity 0.99 0.8
      windowrule = match:tag projects, opacity 0.9 0.8
      windowrule = match:tag im, opacity 0.94 0.86
      windowrule = match:tag file-manager, opacity 0.9 0.8
      windowrule = match:tag terminal, opacity 0.9 0.7

      # ── Float rules ──────────────────────────────────────────────────
      windowrule = match:class ^(mpv)$, float on
      windowrule = match:class ^([Qq]alculate-gtk)$, float on
      windowrule = match:title ^(Authentication Required)$, float on, center on
      windowrule = match:class ^([Ss]team)$, match:title negative:^([Ss]team)$, float on
      windowrule = match:title ^(Save As)$, float on, size (monitor_w*0.7) (monitor_h*0.6), center on

      # ── Fullscreen idle inhibit ───────────────────────────────────────
      windowrule = match:fullscreen true, idle_inhibit fullscreen

      # ── Games ─────────────────────────────────────────────────────────
      windowrule = match:tag games, no_blur on, fullscreen 0
      windowrule = match:tag multimedia_video, no_blur on, opacity 1.0

      # ── Layer rules ───────────────────────────────────────────────────
      layerrule = match:namespace rofi, blur on
      layerrule = match:namespace notifications, blur on
      layerrule = animation slide, match:namespace rofi
      layerrule = animation slide, match:namespace notifications

      # ── Named block rules ─────────────────────────────────────────────
      windowrule {
          name = Picture-in-Picture
          match:title = ^[Pp]icture-in-[Pp]icture$
          float = on
          move = 72% 7%
          opacity = 0.95 0.75
          pin = on
          keep_aspect_ratio = on
          size = (monitor_w*0.3) (monitor_h*0.3)
      }

      windowrule {
          name = 1password-float
          match:class = ^(1Password)$
          float = on
          center = on
      }

      windowrule {
          name = 1password-qa
          match:title = ^(Quick Access — 1Password)$
          float = on
          stay_focused = on
      }

      windowrule {
          name = vivaldi-idle
          match:class = ^(vivaldi)$
          idle_inhibit = fullscreen
      }

      windowrule {
          name = Settings-tag
          match:tag = settings
          float = on
          center = on
          size = (monitor_w*0.7) (monitor_h*0.7)
          opacity = 0.8 0.7
      }

      windowrule {
          name = Thunar-dialogs
          match:class = ([Tt]hunar)
          match:title = negative:(.*[Tt]hunar.*)
          float = on
          center = on
      }
    '';
  };
}
