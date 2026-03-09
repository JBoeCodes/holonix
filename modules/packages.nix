{ pkgs, ... }:

{
  users.users.jboe.packages = with pkgs; [
    claude-code
    codex
    gemini-cli
    git
    opencode
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
    microsoft-edge
    obsidian
    obs-studio
    ani-cli
    fzf
    ripgrep
    eza
    bat
    zoxide
    fd
    duf
    lazygit
    cmatrix
    pipes-rs
    cbonsai
  ];

  programs.firefox = {
    enable = true;
    preferences = {
      "media.ffmpeg.vaapi.enabled" = true;
      "gfx.webrender.all" = true;
      "widget.dmabuf.force-enabled" = true;
    };
  };

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_DMA_BUF = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };
}
