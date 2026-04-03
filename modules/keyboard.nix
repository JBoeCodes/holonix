{ ... }:
{
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "";
  };

  # dconf is still needed for GTK apps
  programs.dconf.enable = true;
}
