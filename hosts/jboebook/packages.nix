{ config, pkgs, ... }:

{
  # System packages - using environment.systemPackages only for truly system-wide tools
  environment.systemPackages = with pkgs; [
    # System administration tools
    git
    zsh
    
    # Laptop-specific tools
    brightnessctl  # Screen brightness control
    acpi           # Battery information
  ];

  # Enable zsh system-wide
  programs.zsh.enable = true;
}