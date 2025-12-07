{ config, pkgs, lib, ... }:

{
  # Enable Hyprland Wayland compositor
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # XDG portal configuration for Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    config.common.default = "*";
  };

  # Required for Hyprland
  environment.systemPackages = with pkgs; [
    # Hyprland utilities
    dunst           # Notification daemon
    swaylock        # Screen locker
    swayidle        # Idle management
    wl-clipboard    # Clipboard utilities
    grim            # Screenshot tool
    slurp           # Screen area selector
    swww            # Wallpaper daemon
    xdg-utils       # XDG utilities

    # Qt Wayland support
    qt5.qtwayland
    qt6.qtwayland
  ];

  # Enable polkit for authentication
  security.polkit.enable = true;

  # Session management
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";  # Enable Wayland for Electron apps
  };
}
