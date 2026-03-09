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
    heroic
    slack
    vlc
    waveterm
    cider-2
    zoom-us
  ];

  programs.firefox.enable = true;
}
