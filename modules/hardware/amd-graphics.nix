{ config, lib, pkgs, ... }:

{
  # AMD graphics configuration for 2015 iMac
  # 2015 iMacs typically have AMD Radeon R9 M380/M390/M395/M395X
  
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    
    extraPackages = with pkgs; [
      # RADV Vulkan driver
      amdvlk
      # Mesa RADV and RadeonSI
      mesa
    ];
    
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  # AMD GPU driver
  services.xserver.videoDrivers = [ "amdgpu" ];
  
  # Enable GPU scheduling for better performance
  boot.kernelParams = [ "amdgpu.gpu_recovery=1" ];
}