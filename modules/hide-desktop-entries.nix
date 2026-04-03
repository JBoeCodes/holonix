{ pkgs, ... }:

let
  hiddenEntries = [
    "xterm"
    "uuctl"
    "waypaper"
    "gtk3-demo"
    "gtk3-icon-browser"
    "gtk3-widget-factory"
    "nixos-manual"
    "org.freedesktop.IBus.Panel.Emojier"
    "org.freedesktop.IBus.Panel.Extension.Gtk3"
    "org.freedesktop.IBus.Panel.Wayland.Gtk3"
    "org.freedesktop.IBus.Setup"
    "org.freedesktop.Xwayland"
    "gcm-calibrate"
    "gcm-import"
    "gcm-picker"
    "geoclue-where-am-i"
    "xdg-desktop-portal-gtk"
    "user-dirs-update-gtk"
    "bluetooth-sendto"
  ];

  hideDesktopEntriesPkg = pkgs.runCommand "hide-desktop-entries" { } ''
    mkdir -p $out/share/applications
    ${builtins.concatStringsSep "\n" (map (name: ''
      cat > $out/share/applications/${name}.desktop <<'ENTRY'
    [Desktop Entry]
    Type=Application
    Name=${name}
    NoDisplay=true
    ENTRY
    '') hiddenEntries)}
  '';
in
{
  users.users.jboe.packages = [ hideDesktopEntriesPkg ];
}
