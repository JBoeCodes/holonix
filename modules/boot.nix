{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages;
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_drm" ];
  boot.kernelParams = [ "nvidia.NVreg_EnableGpuFirmware=0" ];
}
