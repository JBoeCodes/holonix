{ pkgs, ... }:

{
  services.flatpak.enable = true;

  # Ensure portal support for Flatpak apps
  xdg.portal.enable = true;
}
