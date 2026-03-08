{ pkgs, ... }:

{
  users.users.jboe.packages = with pkgs; [
    claude-code
    _1password-cli
    git
    wget
    kitty
    curl
    unzip
    btop
    fastfetch
    gh
    vlc
  ];

  programs.firefox.enable = true;
}
