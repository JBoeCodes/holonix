{ config, lib, pkgs, ... }:

{
  # Hostname is set in each host's configuration.nix
  networking.networkmanager.enable = true;
}