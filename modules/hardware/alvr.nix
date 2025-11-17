{ config, lib, pkgs, ... }:

{
  # ALVR - Air Light VR for Quest wireless streaming to SteamVR
  
  # Install ALVR package
  environment.systemPackages = with pkgs; [
    alvr                # ALVR server for wireless VR streaming
  ];

  # Open firewall ports for ALVR
  networking.firewall = {
    allowedUDPPorts = [
      9943   # ALVR discovery
      9944   # ALVR streaming
    ];
    allowedTCPPorts = [
      9943   # ALVR discovery  
    ];
    allowedUDPPortRanges = [
      { from = 8000; to = 8010; }  # Additional ALVR streaming ports
    ];
  };

  # Enable hardware video encoding for ALVR
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # Already enabled in nvidia.nix but ensuring video encoding support
      nvidia-vaapi-driver
    ];
  };

  # Ensure SteamVR compatibility
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;  # Also helps with Quest connectivity
  };
}