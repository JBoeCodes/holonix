{ config, lib, pkgs, ... }:

with lib;

{
  config = mkIf (config.networking.hostName == "nixpad") {
  # Intel integrated graphics configuration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  
  # Intel video driver
  services.xserver.videoDrivers = [ "modesetting" ];
  
  # Enable hardware video acceleration
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver # LIBVA_DRIVER_NAME=iHD
    intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but sometimes works better)
    libva-vdpau-driver
    libvdpau-va-gl
  ];
  };
}