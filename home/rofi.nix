{ pkgs, ... }:
{
  stylix.targets.rofi.enable = false;

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "kitty";

    extraConfig = {
      modi = "drun";
      show-icons = true;
      icon-theme = "Papirus-Dark";
      drun-display-format = "{name}";
      display-drun = "Apps";
      hover-select = true;
      me-select-entry = "MouseSecondary";
      me-accept-entry = "MousePrimary";
    };

    theme = ../dotfiles/rofi/themes/glass-grid.rasi;
  };
}
