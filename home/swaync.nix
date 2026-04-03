{ ... }:
{
  services.swaync = {
    enable = true;

    settings = {
      positionX = "center";
      positionY = "top";
      layer = "overlay";
      control-center-width = 450;
      control-center-height = 720;
      notification-window-width = 400;
      timeout = 6;
      timeout-low = 3;
      timeout-critical = 0;
      fit-to-screen = true;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = true;
      hide-on-action = true;

      widgets = [
        "dnd"
        "buttons-grid"
        "mpris"
        "volume"
        "backlight"
        "title"
        "notifications"
      ];

      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear";
        };
        dnd = {
          text = "Do Not Disturb";
        };
        volume = {
          label = "";
          show-per-app = true;
        };
        buttons-grid = {
          actions = [
            {
              label = "Lock";
              command = "loginctl lock-session";
            }
            {
              label = "Mute";
              command = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            }
          ];
        };
      };
    };

    style = ''
      .notification-row {
        margin-bottom: 4px;
      }
      .notification {
        border-radius: 10px;
        padding: 8px;
      }
      .close-button {
        border-radius: 50%;
        min-width: 24px;
        min-height: 24px;
      }
      .control-center {
        border-radius: 12px;
        padding: 12px;
      }
    '';
  };
}
