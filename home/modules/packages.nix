{ config, pkgs, pkgs-unstable, ... }:

{
  # User packages managed by Home Manager
  home.packages = with pkgs; [
    git
    imagemagick  # Color extraction for matugen
  ] ++ [
    pkgs-unstable.matugen  # Dynamic theming from wallpapers
  ] ++ (with pkgs; [
    neovim
    claude-code
    firefox
    spotify
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
    ffmpeg
    nixfmt-classic
    libnotify  # For wallpaper picker notifications
  ]);
}
