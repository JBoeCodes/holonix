{ config, lib, pkgs, ... }:

{
  # Enable CIFS/SMB support
  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  # Enable services for SMB mounting
  services.gvfs.enable = true;
}