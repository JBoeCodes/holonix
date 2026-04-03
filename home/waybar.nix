{ pkgs, config, ... }:
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        spacing = 2;
        margin-top = 4;
        margin-left = 8;
        margin-right = 8;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "tray"
          "pulseaudio"
          "network"
          "custom/notification"
        ];

        "hyprland/workspaces" = {
          format = "{id}";
          on-click = "activate";
          sort-by-number = true;
        };

        "hyprland/window" = {
          format = "{}";
          max-length = 50;
          rewrite = {
            "(.*) — Mozilla Firefox" = " $1";
            "(.*) - Visual Studio Code" = " $1";
            "(.*) — Vivaldi" = " $1";
            "(.*) - kitty" = " $1";
          };
        };

        clock = {
          format = "{:%I:%M %p}";
          format-alt = "{:%A, %B %d, %Y}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " Muted";
          format-icons = {
            default = ["" "" ""];
          };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        };

        network = {
          format-wifi = " {essid}";
          format-ethernet = " {ifname}";
          format-disconnected = " Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
        };

        tray = {
          icon-size = 18;
          spacing = 8;
        };

        "custom/notification" = {
          tooltip = false;
          format = "{}";
          "return-type" = "json";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          escape = true;
        };
      };
    };

    # Let Stylix handle base colors, add layout-specific overrides
    style = ''
      * {
        min-height: 0;
      }

      window#waybar {
        border-radius: 10px;
      }

      #workspaces button {
        padding: 0 8px;
        border-radius: 8px;
        margin: 2px 2px;
      }

      #workspaces button.active {
        font-weight: bold;
      }

      #clock, #pulseaudio, #network, #tray, #custom-notification {
        padding: 0 12px;
        margin: 4px 2px;
        border-radius: 8px;
      }

      #window {
        padding: 0 12px;
        font-style: italic;
      }
    '';
  };
}
