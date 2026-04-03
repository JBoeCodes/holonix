{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;

    # Font managed by Stylix (JetBrainsMono Nerd Font, size 14)

    settings = {
      # Window (background_opacity managed by Stylix)
      confirm_os_window_close = 0;
      window_padding_width = 8;

      # Cursor
      cursor_shape = "beam";
      cursor_blink_interval = "0.5";

      # Scrollback
      scrollback_lines = 10000;

      # Bell
      enable_audio_bell = false;

      # URLs
      url_style = "curly";
      detect_urls = true;

      # Misc
      copy_on_select = "clipboard";
      mouse_hide_wait = 3;
      shell_integration = "enabled";

      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;
    };

    keybindings = {
      # Tabs
      "ctrl+t" = "new_tab";
      "ctrl+shift+left" = "previous_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+w" = "close_tab";

      # Splits
      "ctrl+d" = "launch --location=vsplit --cwd=current";
      "ctrl+shift+d" = "launch --location=hsplit --cwd=current";
      "ctrl+left" = "neighboring_window left";
      "ctrl+right" = "neighboring_window right";
      "ctrl+up" = "neighboring_window up";
      "ctrl+down" = "neighboring_window down";

      # Font size
      "ctrl+plus" = "change_font_size all +1.0";
      "ctrl+minus" = "change_font_size all -1.0";
      "ctrl+0" = "change_font_size all 0";

      # Split management
      "ctrl+shift+e" = "layout_action equalize";
      "ctrl+shift+f" = "toggle_layout stack";

      # Reload
      "ctrl+shift+comma" = "load_config_file";
    };
  };
}
