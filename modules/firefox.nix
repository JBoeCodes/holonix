{ ... }:

{
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
