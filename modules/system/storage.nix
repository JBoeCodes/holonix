{ config, lib, pkgs, ... }:

{
  fileSystems."/home/jboe/Games" = {
    device = "/dev/disk/by-uuid/47b89a46-b397-4560-876d-e5ac34ad6e7a";
    fsType = "ext4";
    options = [ "defaults" "nofail" "user" "rw" "exec" ];
  };

  fileSystems."/home/jboe/Projects" = {
    device = "/dev/disk/by-uuid/093bb592-ebb5-4a34-9bf2-bcff57cd7056";
    fsType = "ext4";
    options = [ "defaults" "nofail" "user" "rw" "exec" ];
  };

  # SMB network shares
  fileSystems."/home/jboe/Media" = {
    device = "//192.168.0.6/media-share";
    fsType = "cifs";
    options = [
      "credentials=/home/jboe/nixos/secrets/smb-credentials"
      "uid=1000"
      "gid=100"
      "iocharset=utf8"
      "nofail"
      "x-systemd.automount"
      "x-systemd.device-timeout=10"
    ];
  };

  fileSystems."/home/jboe/Files" = {
    device = "//192.168.0.6/file-share";
    fsType = "cifs";
    options = [
      "credentials=/home/jboe/nixos/secrets/smb-credentials"
      "uid=1000"
      "gid=100"
      "iocharset=utf8"
      "nofail"
      "x-systemd.automount"
      "x-systemd.device-timeout=10"
    ];
  };

  fileSystems."/home/jboe/Movies" = {
    device = "//192.168.0.6/movie-share";
    fsType = "cifs";
    options = [
      "credentials=/home/jboe/nixos/secrets/smb-credentials"
      "uid=1000"
      "gid=100"
      "iocharset=utf8"
      "nofail"
      "x-systemd.automount"
      "x-systemd.device-timeout=10"
    ];
  };

  fileSystems."/home/jboe/Shows" = {
    device = "//192.168.0.6/show-share";
    fsType = "cifs";
    options = [
      "credentials=/home/jboe/nixos/secrets/smb-credentials"
      "uid=1000"
      "gid=100"
      "iocharset=utf8"
      "nofail"
      "x-systemd.automount"
      "x-systemd.device-timeout=10"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /home/jboe/Games 0755 jboe users -"
    "d /home/jboe/Projects 0755 jboe users -"
    "d /home/jboe/Media 0755 jboe users -"
    "d /home/jboe/Files 0755 jboe users -"
    "d /home/jboe/Movies 0755 jboe users -"
    "d /home/jboe/Shows 0755 jboe users -"
    "L+ /mnt/games - - - - /home/jboe/Games"
    "L+ /mnt/projects - - - - /home/jboe/Projects"
    "L+ /mnt/media - - - - /home/jboe/Media"
    "L+ /mnt/files - - - - /home/jboe/Files"
    "L+ /mnt/movies - - - - /home/jboe/Movies"
    "L+ /mnt/shows - - - - /home/jboe/Shows"
  ];
}