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
      settings."org/gnome/mutter" = {
        overlay-key = "Super_L";
      };
      settings."org/gnome/shell/keybindings" = {
        show-screenshot-ui = [ "<Super><Shift>s" ];
      };
      settings."org/gnome/desktop/wm/keybindings" = {
        close = [ "<Super>w" ];
      };
      settings."org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };
      settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "1Password Quick Access";
        command = "1password --quick-access";
        binding = "<Control><Shift>space";
      };
    }];
  };
}
