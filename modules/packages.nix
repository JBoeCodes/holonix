{ pkgs, ... }:

{
  users.users.jboe.packages = with pkgs; [
    claude-code
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
    onlyoffice-desktopeditors
    obsidian
    obs-studio
    flameshot
    ani-cli
  ];

  programs.firefox.enable = true;
}
