{ config, lib, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hide ACPI errors and reduce boot verbosity
  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "acpi.debug_level=0"
    "acpi.debug_layer=0"
  ];
}