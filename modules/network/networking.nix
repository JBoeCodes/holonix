{ config, lib, pkgs, ... }:

{
  networking.hostName = "jboedesk";
  networking.networkmanager.enable = true;
}