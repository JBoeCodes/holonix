{ config, lib, pkgs, ... }:

{
  fileSystems."/home/jboe/Games" = {
    device = "/dev/disk/by-uuid/47b89a46-b397-4560-876d-e5ac34ad6e7a";
    fsType = "ext4";
    options = [ "defaults" "nofail" "user" "rw" "exec" ];
  };

  systemd.tmpfiles.rules = [
    "d /home/jboe/Games 0755 jboe users -"
    "L+ /mnt/games - - - - /home/jboe/Games"
  ];
}