{ config, lib, pkgs, ... }:

{
  # Essential system utilities and tools
  environment.systemPackages = with pkgs; [
    # Core utilities
    vim
    wget
    git
    tree
    unzip
    zip
    
    # System monitoring
    htop
    neofetch
    powertop
    
    # Terminal utilities
    alacritty
  ];
}