{ config, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ./modules/kitty.nix
    ./modules/packages.nix
    ./modules/zsh.nix
    ./modules/fastfetch.nix
    ./modules/matugen.nix
    ./modules/hypr/hyprland.nix
    ./modules/hypr/rofi.nix
    ./modules/hypr/waybar.nix
    ./modules/hypr/theme-picker.nix
    ./modules/hypr/keybind-cheatsheet.nix
  ];

  home.username = "jboe";
  home.homeDirectory = "/home/jboe";

  home.stateVersion = "25.05";

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Configure programs managed by Home Manager
  programs = {

  # Enable bash with home-manager
    bash = {
      enable = true;
      bashrcExtra = ''
        # Add any custom bash configuration here
      '';
    };
  };
}
