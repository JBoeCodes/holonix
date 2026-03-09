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
      settings."org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };
      settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "Screenshot";
        command = "gnome-screenshot -a";
        binding = "<Super><Shift>s";
      };
    }];
  };
}
