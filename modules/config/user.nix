{ config, lib, pkgs, ... }:

{
  users.users.jboe = {
    isNormalUser = true;
    description = "jboe";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}