{ config, lib, pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  hardware.graphics = {
    enable32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    steam
    steam-run
  ];
}