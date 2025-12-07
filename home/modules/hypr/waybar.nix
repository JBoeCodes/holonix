{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 42;
        margin = "8 12 0 12";
        spacing = 8;

        modules-left = [ "hyprland/workspaces" "hyprland/submap" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "battery" "clock" "tray" ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
          on-click = "activate";
          sort-by-number = true;
        };

        "hyprland/window" = {
          format = "{}";
          icon = true;
          icon-size = 20;
          max-length = 60;
          separate-outputs = true;
        };

        clock = {
          format = "󰥔 {:%H:%M}";
          format-alt = "󰃭 {:%A, %B %d, %Y}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            format = {
              months = "<span color='#a6e3a1'><b>{}</b></span>";
              days = "<span color='#cdd6f4'>{}</span>";
              weekdays = "<span color='#f9e2af'><b>{}</b></span>";
              today = "<span color='#f38ba8'><b><u>{}</u></b></span>";
            };
          };
        };

        cpu = {
          interval = 2;
          format = "󰻠 {usage}%";
          tooltip = true;
          tooltip-format = "CPU: {usage}%";
        };

        memory = {
          interval = 2;
          format = "󰍛 {percentage}%";
          tooltip = true;
          tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G";
        };

        battery = {
          interval = 10;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          tooltip-format = "{timeTo} {capacity}%";
        };

        network = {
          interval = 3;
          format-wifi = "󰖩 {essid}";
          format-ethernet = "󰈀 Connected";
          format-linked = "󰈀 {ifname} (No IP)";
          format-disconnected = "󰖪 Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}\n󰕒 {bandwidthDownBits} 󰕘 {bandwidthUpBits}";
          on-click = "nm-connection-editor";
        };

        pulseaudio = {
          scroll-step = 5;
          format = "{icon} {volume}%";
          format-muted = "󰖁 Muted";
          format-icons = {
            default = ["󰕿" "󰖀" "󰕾"];
            headphone = "󰋋";
            headset = "󰋎";
          };
          on-click = "pavucontrol";
          tooltip-format = "{desc}\nVolume: {volume}%";
        };

        tray = {
          icon-size = 18;
          spacing = 12;
        };
      };
    };

    style = ''
      /* Import matugen-generated colors */
      @import "colors.css";

      * {
        border: none;
        border-radius: 12px;
        font-family: "Hack Nerd Font", "Symbols Nerd Font", "Font Awesome 6 Free";
        font-size: 14px;
        font-weight: 500;
        min-height: 0;
        transition: all 0.3s ease-in-out;
      }

      window#waybar {
        background: transparent;
        color: @fg;
      }

      tooltip {
        background: @bg;
        border: 1px solid @border;
        border-radius: 12px;
        padding: 10px;
        color: @fg;
      }

      tooltip label {
        color: @fg;
      }

      #workspaces {
        background: @bg;
        padding: 4px 8px;
        margin-left: 0;
        border: 1px solid @border;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
      }

      #workspaces button {
        padding: 4px 12px;
        margin: 2px 4px;
        background: transparent;
        color: @fg-alt;
        border-radius: 8px;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      }

      #workspaces button:hover {
        background: @selected;
        box-shadow: 0 2px 8px @border;
      }

      #workspaces button.active {
        background: @selected;
        color: @fg;
        box-shadow: 0 0 12px @border;
        font-weight: 600;
      }

      #workspaces button.urgent {
        background: @urgent;
        color: @fg;
        box-shadow: 0 0 12px @urgent;
      }

      #window {
        background: @bg;
        padding: 8px 20px;
        color: @fg;
        border: 1px solid @border;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
        font-weight: 500;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #tray {
        background: @bg;
        padding: 8px 16px;
        margin: 0;
        border: 1px solid @border;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
      }

      #clock {
        color: @fg-alt;
        font-weight: 600;
        margin-right: 0;
      }

      #battery {
        color: #a6e3a1;
      }

      #battery.charging {
        color: #a6e3a1;
        background: linear-gradient(135deg, rgba(166, 227, 161, 0.15), rgba(148, 226, 213, 0.15));
      }

      #battery.warning:not(.charging) {
        color: #f9e2af;
        background: linear-gradient(135deg, rgba(249, 226, 175, 0.15), rgba(250, 179, 135, 0.15));
      }

      #battery.critical:not(.charging) {
        color: #f38ba8;
        background: linear-gradient(135deg, rgba(243, 139, 168, 0.2), rgba(235, 160, 172, 0.2));
        box-shadow: 0 4px 16px rgba(243, 139, 168, 0.6);
      }

      #cpu {
        color: #f5c2e7;
      }

      #cpu.warning {
        background: linear-gradient(135deg, rgba(245, 194, 231, 0.15), rgba(203, 166, 247, 0.15));
      }

      #memory {
        color: #cba6f7;
      }

      #memory.warning {
        background: linear-gradient(135deg, rgba(203, 166, 247, 0.15), rgba(180, 190, 254, 0.15));
      }

      #network {
        color: #94e2d5;
      }

      #network.disconnected {
        color: #f38ba8;
        background: linear-gradient(135deg, rgba(243, 139, 168, 0.15), rgba(235, 160, 172, 0.15));
      }

      #pulseaudio {
        color: #89dceb;
      }

      #pulseaudio.muted {
        color: #6c7086;
        background: linear-gradient(135deg, rgba(108, 112, 134, 0.15), rgba(88, 91, 112, 0.15));
      }

      #tray {
        padding: 8px 12px;
      }

      #tray > .passive {
        opacity: 0.7;
      }

      #tray > .needs-attention {
        background: linear-gradient(135deg, rgba(243, 139, 168, 0.2), rgba(235, 160, 172, 0.2));
        box-shadow: 0 0 12px rgba(243, 139, 168, 0.5);
      }

      #submap {
        background: linear-gradient(135deg, rgba(249, 226, 175, 0.3), rgba(250, 179, 135, 0.3));
        padding: 8px 16px;
        color: #1e1e2e;
        font-weight: 700;
        border: 1px solid rgba(249, 226, 175, 0.5);
        box-shadow: 0 4px 20px rgba(249, 226, 175, 0.7);
      }
    '';
  };
}
