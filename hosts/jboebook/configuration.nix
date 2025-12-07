{ config, lib, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ../../modules/default.nix
  ];

  networking.hostName = "jboebook";
  system.stateVersion = "25.05";
}
