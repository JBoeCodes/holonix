{ config, lib, pkgs, ... }:

{
  programs.zsh.enable = true;

  users.users.jboe = {
    isNormalUser = true;
    description = "jboe";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
}