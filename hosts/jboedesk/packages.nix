{ config, pkgs, ... }:

let
  zen-browser = pkgs.callPackage ../../modules/zen-browser.nix { };
in

{
  # User packages
  users.users.jboe = {
    packages = with pkgs; [
      alacritty
      git
      neovim
      claude-code
      zen-browser
      spotify
    ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # Add system-wide packages here if needed
  ];

  # Default web browser configuration
  environment.sessionVariables.DEFAULT_BROWSER = "${zen-browser}/bin/zen-browser";
  
  # Set Zen Browser as default browser for xdg-open
  xdg.mime.defaultApplications = {
    "text/html" = "zen-browser.desktop";
    "x-scheme-handler/http" = "zen-browser.desktop";
    "x-scheme-handler/https" = "zen-browser.desktop";
    "x-scheme-handler/about" = "zen-browser.desktop";
    "x-scheme-handler/unknown" = "zen-browser.desktop";
  };
}
