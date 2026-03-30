{ pkgs, ... }:

{
  # Load ASUS EC sensor driver with force flag (required for Z690 boards)
  # and it87 as fallback SuperIO sensor driver
  boot.kernelModules = [ "asus-ec-sensors" "it87" ];
  boot.extraModprobeConfig = ''
    options asus-ec-sensors force=1
  '';

  hardware.fancontrol.enable = true;

  environment.systemPackages = with pkgs; [
    lm_sensors
  ];
}
