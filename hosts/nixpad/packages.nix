{ config, pkgs, pkgs-unstable, ... }:

{
  environment.systemPackages = with pkgs; [
    # System utilities
    vim
    wget
    git
    htop
    neofetch
    tree
    unzip
    zip
    
    # Development tools
    vscode
    
    # Terminal utilities
    alacritty
    
    # Browser
    firefox
    
    
    # System monitoring
    powertop
    
    # From unstable channel (commented out until package is available)
    # (pkgs-unstable.zen-browser)
  ];
}