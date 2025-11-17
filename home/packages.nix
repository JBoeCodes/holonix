{ config, pkgs, ... }:

let
  zen-browser = pkgs.callPackage ./zen-browser.nix { };
in

{
  # User packages managed by Home Manager
  home.packages = with pkgs; [
    alacritty
    git
    neovim
    claude-code
    zen-browser
    qutebrowser
    nyxt
    librewolf
    floorp
    spotify
    syncthing
    syncthingtray
    code-cursor
    ventoy
  ];

  # Set Zen Browser as default browser
  home.sessionVariables.DEFAULT_BROWSER = "${zen-browser}/bin/zen-browser";
  
  # Configure default applications through Home Manager
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen-browser.desktop";
      "x-scheme-handler/http" = "zen-browser.desktop";
      "x-scheme-handler/https" = "zen-browser.desktop";
      "x-scheme-handler/about" = "zen-browser.desktop";
      "x-scheme-handler/unknown" = "zen-browser.desktop";
    };
  };
}
