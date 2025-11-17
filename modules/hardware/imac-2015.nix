{ config, lib, pkgs, ... }:

{
  # Hardware-specific configuration for 2015 iMac 27"
  
  # Enable firmware updates
  services.fwupd.enable = true;
  
  # Thunderbolt support
  services.hardware.bolt.enable = true;
  
  # Audio configuration for built-in speakers/microphone
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  
  # Bluetooth support (for peripherals)
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  
  # Webcam support (FaceTime HD camera)
  hardware.facetimehd.enable = true;
  
  # High DPI display support
  # 2015 iMac 27" has 5K display (5120x2880)
  services.xserver.dpi = 218; # Adjust if needed
  
  # Enable Apple keyboard function keys
  boot.kernelModules = [ "hid_apple" ];
  boot.kernelParams = [ 
    "hid_apple.fnmode=2"  # Make function keys work as F1, F2, etc. by default
  ];
  
  # Temperature monitoring
  environment.systemPackages = with pkgs; [
    lm_sensors
    hddtemp
  ];
}