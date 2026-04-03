{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "kitty";

    extraConfig = {
      modi = "drun,run,filebrowser,window";
      show-icons = true;
      icon-theme = "Papirus-Dark";
      drun-display-format = "{icon} {name}";
      display-drun = "Apps";
      display-run = "Run";
      display-filebrowser = "Files";
      display-window = "Windows";
    };
  };
}
