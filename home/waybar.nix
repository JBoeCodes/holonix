{ pkgs, config, ... }:
{
  # Disable Stylix's waybar theming — we use our own liquid glass style
  stylix.targets.waybar.enable = false;

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        reload_style_on_change = true;
        spacing = 0;

        modules-left = [
          "hyprland/workspaces"
          "custom/cava"
          "hyprland/window"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "group/tray-expander"
          "custom/notification"
          "network"
          "custom/gpu"
          "cpu"
          "pulseaudio"
        ];

        "hyprland/workspaces" = {
          on-click = "activate";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          format = "{icon}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "10";
          };
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
          };
        };

        "hyprland/window" = {
          format = "<span weight='bold'>{class}</span>";
          max-length = 20;
          icon = true;
          icon-size = 14;
        };

        clock = {
          format = "{:%A %H:%M}";
          format-alt = "{:%d %B W%V %Y}";
          tooltip = false;
        };

        cpu = {
          interval = 5;
          format = "{usage}% 󰍛";
          on-click = "kitty -e btop";
          tooltip-format = "CPU: {usage}%\nLoad: {load}";
        };

        network = {
          format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
          format = "{icon}";
          format-wifi = "{icon}";
          format-ethernet = "󰀂";
          format-disconnected = "󰖪";
          tooltip-format-wifi = "{essid} ({frequency} GHz)\nIP: {ipaddr}\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-ethernet = "IP: {ipaddr}\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-disconnected = "Disconnected";
          interval = 3;
          on-click-right = "nm-connection-editor";
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-muted = "󰝟 {volume}%";
          on-click = "pavucontrol";
          on-click-middle = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          tooltip-format = "{volume}% | {format_source}";
          tooltip-format-muted = "Muted ({volume}%)";
          scroll-step = 5;
          format-icons = {
            default = [ "" "" "" ];
          };
        };

        "group/tray-expander" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 600;
            children-class = "tray-group-item";
          };
          modules = [
            "custom/expand-icon"
            "tray"
          ];
        };

        "custom/expand-icon" = {
          format = " ";
          tooltip = false;
        };

        tray = {
          icon-size = 12;
          spacing = 12;
        };

        "custom/notification" = {
          tooltip = false;
          format = "{}";
          "return-type" = "json";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          escape = true;
        };

        "custom/gpu" = {
          exec = "~/.config/waybar/scripts/waybar-gpu.sh";
          interval = 5;
          "return-type" = "json";
          tooltip = true;
        };

        "custom/cava" = {
          format = "{}";
          exec = "~/.config/waybar/scripts/cava.sh";
        };

      };
    };

    # Liquid glass style with hybrid group layout
    style = ''
      * {
        font-family: 'JetBrainsMono Nerd Font';
        font-size: 13px;
        font-weight: bold;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      tooltip {
        background: rgba(0, 0, 0, 0.75);
        border-radius: 12px;
        border: 1px solid rgba(255, 255, 255, 0.12);
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.3);
      }

      tooltip label {
        color: rgba(255, 255, 255, 0.9);
        padding: 5px;
      }

      window#waybar {
        background-color: transparent;
        transition-property: background-color;
        transition-duration: 0.5s;
        margin: 6px 10px;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      /* --- Glass group containers --- */
      .modules-left,
      .modules-right {
        background: rgba(255, 255, 255, 0.12);
        border-radius: 12px;
        border: 1px solid rgba(255, 255, 255, 0.15);
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.2),
                    inset 0 1px 0 rgba(255, 255, 255, 0.1);
        margin: 4px 6px;
        padding: 0 4px;
      }

      .modules-center {
        background: transparent;
        margin: 4px;
      }

      /* --- Workspaces --- */
      #workspaces {
        background-color: transparent;
        margin: 0;
        padding: 0 2px;
        border-radius: 0;
      }

      #workspaces button {
        color: rgba(255, 255, 255, 0.35);
        background-color: transparent;
        margin: 4px 2px;
        padding: 0 6px;
        border-radius: 8px;
        transition: all 0.3s ease;
      }

      #workspaces button:hover {
        background-color: rgba(255, 255, 255, 0.08);
        color: rgba(255, 255, 255, 0.8);
      }

      #workspaces button.active {
        background-color: rgba(245, 194, 231, 0.25);
        color: #f5c2e7;
        min-width: 28px;
        box-shadow: 0 0 8px rgba(245, 194, 231, 0.15);
      }

      #workspaces button.urgent {
        background-color: rgba(243, 139, 168, 0.3);
        color: #f38ba8;
      }

      #workspaces button.empty {
        color: rgba(255, 255, 255, 0.2);
      }

      /* --- Shared module styles inside glass groups --- */
      #window,
      #custom-cava,
      #tray,
      #cpu,
      #network,
      #pulseaudio,
      #custom-notification,
      #custom-gpu,
      #tray-expander {
        background-color: transparent;
        color: rgba(255, 255, 255, 0.85);
        margin: 2px 0;
        padding: 2px 12px;
        border-radius: 8px;
        transition: all 0.3s ease;
      }

      /* --- Floating clock (center, no glass container) --- */
      #clock {
        background: transparent;
        color: rgba(255, 255, 255, 0.95);
        font-weight: 800;
        padding: 2px 16px;
        text-shadow: 0 1px 6px rgba(0, 0, 0, 0.4);
      }

      /* --- Color-coded modules --- */
      #custom-cava {
        color: #f5c2e7;
        padding: 0 10px;
        text-shadow: 0 0 6px rgba(245, 194, 231, 0.2);
      }

      #pulseaudio {
        color: #a6e3a1;
        text-shadow: 0 0 6px rgba(166, 227, 161, 0.2);
      }

      #network {
        color: #89b4fa;
        text-shadow: 0 0 6px rgba(137, 180, 250, 0.2);
      }

      #cpu {
        color: #fab387;
        text-shadow: 0 0 6px rgba(250, 179, 135, 0.2);
      }

      #custom-gpu {
        color: #fab387;
        text-shadow: 0 0 6px rgba(250, 179, 135, 0.2);
      }

      #custom-notification {
        color: #cba6f7;
        text-shadow: 0 0 6px rgba(203, 166, 247, 0.2);
      }

      #window {
        color: rgba(255, 255, 255, 0.7);
      }

      /* --- Tray expander --- */
      #tray-expander {
        padding: 0 4px;
      }

      #custom-expand-icon {
        color: rgba(255, 255, 255, 0.6);
        margin-left: 6px;
      }

      #tray {
        padding: 0 4px;
      }

      /* --- Hover effects --- */
      #cpu:hover,
      #network:hover,
      #pulseaudio:hover,
      #custom-gpu:hover,
      #custom-notification:hover {
        background-color: rgba(255, 255, 255, 0.08);
      }

      #clock:hover {
        text-shadow: 0 1px 8px rgba(0, 0, 0, 0.5);
        color: white;
      }
    '';
  };

  # Deploy waybar helper scripts
  xdg.configFile = {
    "waybar/scripts/waybar-gpu.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        util=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null || echo "N/A")
        temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null || echo "N/A")
        mem=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits 2>/dev/null || echo "N/A")
        mem_total=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits 2>/dev/null || echo "N/A")
        gpu_name=$(nvidia-smi --query-gpu=name --format=csv,noheader,nounits 2>/dev/null || echo "GPU")
        echo "{\"text\": \"󰓹 ''${util}%\", \"tooltip\": \"GPU: ''${gpu_name}\nUsage: ''${util}%\nTemp: ''${temp}°C\nVRAM: ''${mem}MiB / ''${mem_total}MiB\"}"
      '';
    };

    "waybar/scripts/cava.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        bars=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)
        config_file="/tmp/waybar_cava_config"
        cat > "$config_file" <<CAVACFG
        [general]
        bars = 24
        framerate = 60
        autosens = 1
        [output]
        method = raw
        raw_target = /dev/stdout
        data_format = ascii
        ascii_max_range = 7
        CAVACFG

        trap "kill 0" EXIT
        pause_start=0

        convert_to_bars() {
          IFS=';' read -ra nums <<< "$1"
          out=""
          for n in "''${nums[@]}"; do
            (( n >= 0 && n <= 7 )) || n=0
            out+="''${bars[$n]}"
          done
          printf '%s\n' "$out"
        }

        cava -p "$config_file" | \
        while IFS= read -r line; do
          now=$(date +%s)
          if [[ "$line" =~ ^(0\;?)+$ ]]; then
            if (( pause_start == 0 )); then pause_start=$now; fi
            if (( now - pause_start >= 2 )); then echo ""; else convert_to_bars "$line"; fi
            continue
          fi
          pause_start=0
          convert_to_bars "$line"
        done
      '';
    };
  };
}
