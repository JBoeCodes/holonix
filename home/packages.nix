{ config, pkgs, ... }:

{
  # User packages managed by Home Manager
  home.packages = with pkgs; [
    alacritty
    git
    neovim
    claude-code
    brave
    spotify
    ventoy
    parsec-bin
    strawberry
    cmus
    obsidian
    bat
    eza
    fd
    btop
    fastfetch
    dust
    zoxide
    fzf
    mpv
    imagemagick
    ffmpeg
    nixfmt-classic
  ];

  # Set Brave as default browser
  home.sessionVariables.DEFAULT_BROWSER = "${pkgs.brave}/bin/brave";
  
  # Configure default applications through Home Manager
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "brave-browser.desktop";
      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
      "x-scheme-handler/about" = "brave-browser.desktop";
      "x-scheme-handler/unknown" = "brave-browser.desktop";
    };
  };
}
