{ config, pkgs, ... }:

{
  # Enable the X11 windowing system
  services.xserver.enable = true;
  
  # Enable GNOME Desktop Environment
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  # Enable Wayland for GNOME (default but explicitly set)
  services.xserver.displayManager.gdm.wayland = true;
  
  # GNOME services and integrations
  services.gnome.core-utilities.enable = true;
  services.gnome.evolution-data-server.enable = true;
  services.gnome.gnome-keyring.enable = true;
  
  # Core GNOME applications and utilities
  environment.systemPackages = with pkgs; [
    # Core GNOME applications
    gnome-text-editor        # Text editor (new default)
    gedit                    # Classic text editor
    gnome-terminal           # Terminal
    nautilus                 # File manager
    file-roller              # Archive manager
    evince                   # Document viewer
    eog                      # Image viewer (Eye of GNOME)
    gnome-screenshot         # Screenshot tool
    gnome-calculator         # Calculator
    
    # GNOME system tools
    gnome-system-monitor     # System monitor
    gnome-control-center     # Settings
    gnome-disk-utility       # Disk management
    
    # Additional useful applications
    shotwell                 # Photo manager
    gnome-music              # Music player
    totem                    # Video player (Videos app)
    
    # GNOME extensions and customization
    gnome-tweaks             # Advanced settings
    gnome-extensions-app     # Extensions manager
    
    # Network and connectivity
    networkmanagerapplet     # NetworkManager GUI
    
    # Development and productivity
    gnome-builder            # IDE
    
    # Communication
    polari                   # IRC client
    
    # Graphics and multimedia
    gimp                     # Image editor
    
    # Additional GNOME Circle apps
    fragments                # BitTorrent client
    newsflash                # RSS reader
  ];
  
  # Enable GNOME extensions
  services.gnome.gnome-browser-connector.enable = true;
  
  # Enable GDM auto-login (optional - uncomment if desired)
  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = "jboe";
  
  # Enable additional GNOME services
  services.udev.packages = with pkgs; [ gnome-settings-daemon ];
  
  # GTK theming
  programs.dconf.enable = true;
  
  # Exclude some default GNOME applications to keep system clean
  # (uncomment packages you want to exclude)
  environment.gnome.excludePackages = (with pkgs; [
    # gnome-photos
    # gnome-tour
    # gnome-connections
  ]) ++ (with pkgs.gnome; [
    # cheese            # webcam tool
    # gnome-music
    # gnome-maps
    # gnome-weather
    # epiphany          # web browser
    # geary             # email reader
    # yelp              # help viewer
  ]);
  
  # XDG portal for better app integration
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  
  # Enable location services (optional)
  services.geoclue2.enable = true;
  
  # Automatic timezone disabled - manually set in configuration.nix
  # services.automatic-timezoned.enable = true;
}