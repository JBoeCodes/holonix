{ config, lib, pkgs, ... }:

{
  # Monado - Open Source OpenXR Runtime (recommended for NixOS)
  services.monado = {
    enable = true;
    defaultRuntime = true;  # Register as default OpenXR runtime
  };

  # Environment variables for Monado optimization
  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";        # Enable SteamVR Lighthouse tracking
    XRT_COMPOSITOR_COMPUTE = "1";   # Enable compute shaders for better performance
  };

  # Install VR-related packages
  environment.systemPackages = with pkgs; [
    opencomposite     # OpenVR compatibility layer
    wlx-overlay-s     # Desktop overlay for VR
    # monado          # Already included via services.monado
  ];

  # OpenGL and hardware acceleration requirements for VR
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # Required for Steam games
  };

  # Udev rules for VR devices (Index, Vive, etc.)
  services.udev.packages = with pkgs; [
    steamvr  # Includes udev rules for VR devices
  ];

  # Enable USB device access for VR controllers
  services.udev.extraRules = ''
    # HTC Vive and Index controllers
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0bb4", MODE="0664", GROUP="users"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0664", GROUP="users"
    # Oculus devices
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2833", MODE="0664", GROUP="users"
  '';

  # Additional VR-specific system configuration
}