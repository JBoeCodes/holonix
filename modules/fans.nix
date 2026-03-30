{ pkgs, ... }:

{
  # ASUS ROG STRIX Z690-E does not expose PWM fan control to Linux.
  # Fan curves must be configured in BIOS (Q-Fan Control).
  # lm_sensors is included for temperature monitoring only.

  boot.kernelModules = [ "asus-ec-sensors" "it87" ];
  boot.extraModprobeConfig = ''
    options asus-ec-sensors force=1
  '';

  environment.systemPackages = with pkgs; [
    lm_sensors
  ];
}
