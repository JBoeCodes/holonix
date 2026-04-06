{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # XDG portals for Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = [ "hyprland" "gtk" ];
  };

  # Hyprland ecosystem packages (waybar, rofi, swaync, hyprlock, hypridle
  # are installed by Home Manager modules — don't duplicate here)
  users.users.jboe.packages = with pkgs; [
    # Core Hyprland ecosystem
    libnotify
    swww
    hyprpolkitagent
    hyprpicker
    hyprsunset
    wl-clipboard
    cliphist
    networkmanagerapplet
    networkmanager_dmenu

    # Screenshot / recording
    grimblast
    satty
    slurp
    wf-recorder

    # Audio / media
    pavucontrol
    playerctl
    cava

    # Bluetooth
    blueman

    # File manager
    thunar

    # Wallpaper GUI
    waypaper

    # Gaming overlay
    mangohud

    # Qt theming
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    kdePackages.qt6ct

    # Utilities used by KoolDots scripts
    jq
    bc
    socat
    imagemagick
    yad
  ];
}
