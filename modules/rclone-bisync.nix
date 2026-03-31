{ ... }:

{
  systemd.services.rclone-bisync = {
    description = "Rclone bisync between Google Drive and /mnt/projects";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "jboe";
      Group = "users";
      ExecStart = toString [
        "/etc/profiles/per-user/jboe/bin/rclone"
        "bisync"
        "/mnt/projects/"
        "projects:"
        "--exclude" "lost+found/"
        "--recover"
        "--max-lock" "5m"
      ];
    };
  };

  systemd.timers.rclone-bisync = {
    description = "Run rclone bisync every 5 minutes";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2min";
      OnUnitActiveSec = "5min";
      Persistent = true;
    };
  };
}
