{ pkgs, config, ... }:
{
  # Disable Stylix's waybar theming — we use our own omarchy-inspired style
  stylix.targets.waybar.enable = false;

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        reload_style_on_change = true;
        spacing = 0;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [
          "custom/cava"
          "clock"
        ];
        modules-right = [
          "group/tray-expander"
          "custom/notification"
          "network"
          "custom/gpu"
          "cpu"
          "pulseaudio"
          "idle_inhibitor"
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

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰒳";
            deactivated = "󰒲";
          };
          tooltip-format = "{status}";
          tooltip-format-activated = "Idle inhibitor: Active";
          tooltip-format-deactivated = "Idle inhibitor: Inactive";
        };
      };
    };

    # Omarchy-inspired style with Rosé Pine colors
    style = ''
      @define-color bg #191724;
      @define-color fg #e0def4;
      @define-color accent #ebbcba;
      @define-color dark-bg #11111b;
      @define-color hover-bg #26233a;
      @define-color muted #6e6a86;
      @define-color love #eb6f92;
      @define-color gold #f6c177;
      @define-color pine #31748f;
      @define-color foam #9ccfd8;
      @define-color iris #c4a7e7;

      * {
        font-family: 'JetBrainsMono Nerd Font';
        font-size: 13px;
        font-weight: bold;
        border: none;
        border-radius: 20px;
        min-height: 0;
      }

      tooltip {
        background: @dark-bg;
        border-radius: 15px;
        border: 1px solid @accent;
      }

      tooltip label {
        color: @fg;
        padding: 5px;
      }

      window#waybar {
        background-color: transparent;
        transition-property: background-color;
        transition-duration: .5s;
        margin: 10px;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      .modules-left,
      .modules-center,
      .modules-right {
        background: transparent;
        margin: 5px;
      }

      #workspaces {
        background-color: @dark-bg;
        margin: 2px 4px;
        padding: 0 5px;
        border-radius: 20px;
        opacity: 0.9;
      }

      #workspaces button {
        color: @fg;
        background-color: transparent;
        margin: 4px 2px;
        padding: 0 5px;
        border-radius: 20px;
        transition: all 0.3s ease;
      }

      #workspaces button:hover {
        background-color: @hover-bg;
        color: @fg;
      }

      #workspaces button.active {
        background-color: @accent;
        color: @dark-bg;
        min-width: 30px;
      }

      #workspaces button.urgent {
        color: @love;
        background-color: @gold;
      }

      #workspaces button.empty {
        color: @muted;
      }

      #tray,
      #window,
      #cava,
      #cpu,
      #network,
      #pulseaudio,
      #custom-notification,
      #custom-gpu,
      #custom-cava,
      #clock,
      #tray-expander,
      #idle_inhibitor {
        background-color: @dark-bg;
        color: @fg;
        margin: 2px;
        padding: 2px 15px;
        border-radius: 20px;
        opacity: 0.9;
      }

      #window {
        margin: 2px 4px;
      }

      #clock {
        font-weight: 800;
      }

      #custom-cava {
        color: @accent;
        padding: 0 12px;
      }

      #tray-expander {
        padding: 0 5px;
      }

      #custom-expand-icon {
        color: @fg;
        margin-left: 8px;
      }

      #cpu:hover,
      #network:hover,
      #pulseaudio:hover,
      #clock:hover,
      #custom-gpu:hover,
      #custom-notification:hover,
      #idle_inhibitor:hover {
        background-color: @hover-bg;
        color: @accent;
      }

      #custom-notification {
        color: @iris;
      }

      #idle_inhibitor {
        color: @foam;
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
