{ config, pkgs, ... }:

{
  # Install Kitty
  home.packages = [ pkgs.kitty ];

  # Configure Kitty
  programs.kitty = {
    enable = true;

    settings = {
      # Window settings
      hide_window_decorations = "yes";
      window_padding_width = 25;
      background_opacity = "0.75";

      # Font configuration
      font_family = "Hack Nerd Font Mono";
      font_size = 12;

      # Cursor
      cursor_shape = "beam";
      cursor_blink_interval = 0;

      # Scrollback
      scrollback_lines = 10000;

      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = "yes";

      # Enable dynamic theme reloading
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty";
    };

    # Keybindings
    keybindings = {
      "ctrl+n" = "new_window";
    };

    # Theme will be loaded from matugen-generated file
    extraConfig = ''
      # Matugen-generated colors will be loaded here
      include ~/.config/kitty/theme.conf
    '';
  };
}
