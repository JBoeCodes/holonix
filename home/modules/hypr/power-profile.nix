{ config, pkgs, ... }:

{
  # Power profile management scripts for laptop power modes

  # Script to cycle through power profiles (performance → balanced → power-saver)
  home.file.".local/bin/power-profile-cycle" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Get current power profile
      current=$(${pkgs.power-profiles-daemon}/bin/powerprofilesctl get)

      # Cycle to next profile (power-saver → balanced → performance)
      case "$current" in
        "power-saver")
          next="balanced"
          icon="󰾅"
          ;;
        "balanced")
          next="performance"
          icon="󰾅"
          ;;
        "performance")
          next="power-saver"
          icon="󰾆"
          ;;
        *)
          next="balanced"
          icon="󰾅"
          ;;
      esac

      # Set new profile
      ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set "$next"

      # Send notification
      ${pkgs.libnotify}/bin/notify-send "Power Profile" "$icon $next" -u low -t 2000
    '';
  };

  # Script to get current power profile for waybar
  home.file.".local/bin/power-profile-get" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Get current power profile
      profile=$(${pkgs.power-profiles-daemon}/bin/powerprofilesctl get)

      # Output formatted for waybar
      case "$profile" in
        "performance")
          echo '{"text": "󰾅", "tooltip": "Performance Mode", "class": "performance"}'
          ;;
        "balanced")
          echo '{"text": "󰾅", "tooltip": "Balanced Mode", "class": "balanced"}'
          ;;
        "power-saver")
          echo '{"text": "󰾆", "tooltip": "Power Saver Mode", "class": "power-saver"}'
          ;;
        *)
          echo '{"text": "󰾅", "tooltip": "Unknown", "class": "unknown"}'
          ;;
      esac
    '';
  };
}
