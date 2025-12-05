{ config, lib, pkgs, ... }:

with lib;

{
  config = mkIf (elem config.networking.hostName []) {
  # Enable the X11 windowing system
  services.xserver.enable = true;
  
  # Enable KDE Plasma Desktop Environment
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  
  # Enable Wayland for KDE Plasma (optional but recommended for latest features)
  services.displayManager.sddm.wayland.enable = true;
  
  # KDE Connect for device integration
  programs.kdeconnect.enable = true;
  
  # Additional KDE applications and utilities
  environment.systemPackages = with pkgs; [
    # Core KDE applications
    kdePackages.kate          # Text editor
    kdePackages.konsole       # Terminal
    kdePackages.dolphin       # File manager
    kdePackages.ark           # Archive manager
    kdePackages.okular        # Document viewer
    kdePackages.gwenview      # Image viewer
    kdePackages.spectacle     # Screenshot tool
    kdePackages.kcalc         # Calculator
    
    # KDE system tools
    kdePackages.plasma-systemmonitor
    kdePackages.kinfocenter
    kdePackages.partitionmanager
    
    # Additional useful applications
    kdePackages.kdenlive      # Video editor
    krita                     # Digital painting
    kdePackages.kolourpaint   # Simple image editor
    
    # Network and connectivity
    kdePackages.plasma-nm     # NetworkManager integration
    kdePackages.bluedevil     # Bluetooth integration
    
    # Multimedia
    kdePackages.dragon        # Video player
    kdePackages.elisa         # Music player
  ];
  
  # Enable Qt theming
  qt.enable = true;
  qt.platformTheme = "kde";
  qt.style = "breeze";
  
  # Enable phonon backend for audio/video
  environment.variables = {
    # Ensure Qt applications use the KDE platform theme
    QT_QPA_PLATFORMTHEME = "kde";
  };
  };
}
