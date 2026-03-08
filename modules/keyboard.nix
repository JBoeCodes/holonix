{ ... }:
{
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "altwin:swap_alt_win";
  };

  # GNOME on Wayland manages XKB options via dconf
  programs.dconf = {
    enable = true;
    profiles.user.databases = [{
      settings."org/gnome/desktop/input-sources" = {
        xkb-options = [ "altwin:swap_alt_win" ];
      };
    }];
  };
}
