{ pkgs, ... }:

{
  # greetd + tuigreet: minimal, fast, NVIDIA-friendly login manager.
  # Runs on a TTY so it avoids the VT-switching black-screen issues that
  # SDDM exhibits with the proprietary/open NVIDIA stack.

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet "
          + "--time "
          + "--remember "
          + "--remember-user-session "
          + "--asterisks "
          + "--theme 'border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red' "
          + "--cmd 'uwsm start hyprland-uwsm.desktop'";
        user = "greeter";
      };
    };
  };

  # Prevent kernel/systemd log spam from overwriting the tuigreet UI.
  boot.kernelParams = [ "console=tty1" "quiet" ];

  # tuigreet needs a writable cache dir for --remember to persist across reboots.
  systemd.tmpfiles.rules = [
    "d /var/cache/tuigreet 0755 greeter greeter - -"
  ];

  # Keep printing support that previously lived in sddm.nix.
  services.printing.enable = true;
}
