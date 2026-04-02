{ pkgs, ... }:

{
  users.users.jboe.packages = [ pkgs.kitty ];

  # KoolDots manages ~/.config/kitty/kitty.conf directly (with wallust theming).
  # This module only ensures kitty is installed and applies our preference overrides
  # via an activation script that patches the KoolDots config in place.
  system.activationScripts.kittyConfig = ''
    conf="/home/jboe/.config/kitty/kitty.conf"
    if [ -f "$conf" ]; then
      # Replace font with our preferred font
      ${pkgs.gnused}/bin/sed -i 's/^font_family .*/font_family JetBrainsMonoNerdFont/' "$conf"
      ${pkgs.gnused}/bin/sed -i 's/^font_size .*/font_size 14.0/' "$conf"

      # Set our preferred opacity
      ${pkgs.gnused}/bin/sed -i 's/^background_opacity .*/background_opacity 0.85/' "$conf"

      # Increase scrollback
      ${pkgs.gnused}/bin/sed -i 's/^scrollback_lines .*/scrollback_lines 100000/' "$conf"

      # Set window padding to match our ghostty config
      ${pkgs.gnused}/bin/sed -i 's/^window_padding_width .*/window_padding_width 10/' "$conf"

      # Add our custom settings block if not already present
      if ! grep -q '# NixOS overrides' "$conf"; then
        cat >> "$conf" <<'NIXEOF'

# NixOS overrides
cursor_shape beam
cursor_blink_interval 0.5
mouse_hide_wait 3.0
copy_on_select clipboard
confirm_os_window_close 0
shell_integration enabled

# Keybindings (matching previous Ghostty config)
# Tabs
map ctrl+t new_tab
map ctrl+shift+left previous_tab
map ctrl+shift+right next_tab
map ctrl+w close_tab

# Splits (kitty calls them windows)
map ctrl+d launch --location=vsplit --cwd=current
map ctrl+shift+d launch --location=hsplit --cwd=current
map ctrl+left neighboring_window left
map ctrl+right neighboring_window right
map ctrl+up neighboring_window up
map ctrl+down neighboring_window down

# Font size
map ctrl+plus change_font_size all +1.0
map ctrl+minus change_font_size all -1.0
map ctrl+0 change_font_size all 0

# Splits management
map ctrl+shift+e layout_action equalize
map ctrl+shift+f toggle_layout stack

# Reload config
map ctrl+shift+comma load_config_file
NIXEOF
      fi

      chown jboe:users "$conf"
    fi
  '';
}
