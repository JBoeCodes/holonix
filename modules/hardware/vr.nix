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
    # opencomposite     # OpenVR compatibility layer - DISABLED: causes SteamVR conflicts on Linux
    wlx-overlay-s     # Desktop overlay for VR
    polkit            # Required for SteamVR compositor permissions
    libcap            # Required for setcap operations
    # monado          # Already included via services.monado
  ];

  # OpenGL and hardware acceleration requirements for VR
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # Required for Steam games
  };

  # Enable USB device access for VR controllers and headsets
  services.udev.extraRules = ''
    # HTC Vive and Index controllers/headsets
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0bb4", MODE="0664", GROUP="users"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0664", GROUP="users"
    # Oculus devices
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2833", MODE="0664", GROUP="users"
    # Additional VR device support
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0bb4", MODE="0664", GROUP="users"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28de", MODE="0664", GROUP="users"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2833", MODE="0664", GROUP="users"
  '';

  # SteamVR compositor permissions - required for proper VR functionality  
  # Enable polkit service
  security.polkit.enable = true;
  
  # Create specific polkit rule for SteamVR setcap operations
  security.polkit.extraConfig = ''
    /* Allow SteamVR vrcompositor setcap operations */
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.policykit.exec" && 
          action.lookup("command_line") &&
          action.lookup("command_line").indexOf("setcap") != -1 &&
          action.lookup("command_line").indexOf("vrcompositor") != -1 &&
          subject.isInGroup("users")) {
        return polkit.Result.YES;
      }
    });
    
    /* Fallback rule for Steam VR setup scripts */
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.policykit.exec" &&
          action.lookup("program") &&
          (action.lookup("program").indexOf("vrsetup.sh") != -1 ||
           action.lookup("program").indexOf("setcap") != -1) &&
          subject.isInGroup("users")) {
        return polkit.Result.YES;
      }
    });
  '';

  # Enable realtime scheduling for VR processes
  security.pam.loginLimits = [
    { domain = "@users"; item = "rtprio"; type = "-"; value = "99"; }
    { domain = "@users"; item = "memlock"; type = "-"; value = "unlimited"; }
  ];

  # Create OpenVR config directory with proper permissions
  systemd.tmpfiles.rules = [
    "d /home/jboe/.config/openvr 0755 jboe users -"
    "f /home/jboe/.config/openvr/openvrpaths.vrpath 0644 jboe users -"
  ];

  # Additional VR-specific system configuration
}