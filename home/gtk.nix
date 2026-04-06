{ pkgs, ... }:
{
  gtk = {
    enable = true;

    gtk4.theme = null;

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };

  # Prevent Stylix from overriding our icon theme choice
  stylix.targets.gtk.enable = false;

  # Qt theming — Stylix handles colors, we set the engine
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  # Prevent Stylix from conflicting with our Qt config
  stylix.targets.qt.enable = false;
}
