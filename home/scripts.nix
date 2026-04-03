{ config, ... }:
{
  xdg.configFile = {
    # KoolDots scripts needed by Hyprland keybinds
    "hypr/scripts" = {
      source = ../dotfiles/hypr/scripts;
      recursive = true;
      executable = true;
    };

    # User scripts
    "hypr/UserScripts" = {
      source = ../dotfiles/hypr/UserScripts;
      recursive = true;
      executable = true;
    };

    # SwayNC images/icons used by scripts
    "swaync/images" = {
      source = ../dotfiles/swaync/images;
      recursive = true;
    };
  };

  # Wallpapers symlink (scripts expect ~/Pictures/wallpapers)
  home.file."Pictures/wallpapers" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/jboe/wallpapers";
  };
}
