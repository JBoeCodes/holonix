{ config, pkgs, ... }:

{
  # System packages - using environment.systemPackages only for truly system-wide tools
  environment.systemPackages = with pkgs; [
    # System administration tools
    git
    zsh
  ];

  # Enable zsh system-wide
  programs.zsh.enable = true;
}
