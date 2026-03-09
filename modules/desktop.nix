{ pkgs, ... }:

{
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.printing.enable = true;

  environment.systemPackages = [
    pkgs.gnomeExtensions.dash-to-dock
    pkgs.gnomeExtensions.appindicator
  ];

  programs.dconf.profiles.user.databases = [{
    settings."org/gnome/shell" = {
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "appindicatorsupport@rgcjonas.gmail.com"
      ];
    };
  }];
}
