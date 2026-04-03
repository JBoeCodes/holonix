{ ... }:

{
  services.xserver.enable = true;
  services.printing.enable = true;

  services.displayManager = {
    defaultSession = "hyprland-uwsm";
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
}
