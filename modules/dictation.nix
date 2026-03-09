{ pkgs, whisp-away, ... }:

let
  whispAwayPkg = whisp-away.packages.x86_64-linux.default;

  python = pkgs.python3.withPackages (ps: [
    ps.pygobject3
    ps.numpy
    ps.sounddevice
    ps.dbus-python
  ]);

  dictation-overlay = pkgs.stdenv.mkDerivation {
    pname = "dictation-overlay";
    version = "1.0.0";
    src = ./dictation-overlay.py;
    dontUnpack = true;

    nativeBuildInputs = [
      pkgs.wrapGAppsHook4
      pkgs.gobject-introspection
    ];

    buildInputs = [
      pkgs.gtk4
      pkgs.portaudio
      pkgs.glib
    ];

    installPhase = ''
      mkdir -p $out/bin $out/libexec
      cp $src $out/libexec/dictation-overlay.py

      cat > $out/bin/dictation-overlay <<'WRAPPER'
      #!/bin/sh
      exec @python@ @out@/libexec/dictation-overlay.py "$@"
      WRAPPER
      chmod +x $out/bin/dictation-overlay

      substituteInPlace $out/bin/dictation-overlay \
        --replace-warn @python@ ${python}/bin/python3 \
        --replace-warn @out@ $out
    '';

    preFixup = ''
      gappsWrapperArgs+=(
        --prefix GI_TYPELIB_PATH : "${pkgs.gtk4}/lib/girepository-1.0"
        --set YDOTOOL_PATH "${pkgs.ydotool}/bin/ydotool"
        --set WL_COPY_PATH "${pkgs.wl-clipboard}/bin/wl-copy"
      )
    '';
  };

  dictate = pkgs.writeShellScriptBin "dictate" ''
    ${pkgs.dbus}/bin/dbus-send --session --type=method_call \
      --dest=com.jboe.Dictation /com/jboe/Dictation \
      com.jboe.Dictation.Toggle
  '';
in
{
  users.users.jboe.packages = [
    dictate
    whispAwayPkg
  ];

  # ydotool daemon for simulating keypresses on GNOME Wayland
  systemd.user.services.ydotoold = {
    description = "ydotoold - ydotool daemon";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.ydotool}/bin/ydotoold";
      Restart = "on-failure";
    };
  };

  # WhispAway transcription daemon (Vulkan GPU-accelerated, model preloaded)
  systemd.user.services.whisp-away-daemon = {
    description = "WhispAway transcription daemon";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStartPre = "${whispAwayPkg}/bin/download-whisper-model base.en";
      ExecStart = "${whispAwayPkg}/bin/whisp-away daemon --backend whisper-cpp --model base.en";
      Restart = "on-failure";
      RestartSec = 3;
    };
    environment = {
      WA_WHISPER_SOCKET = "/tmp/whisp-away-daemon.sock";
    };
  };

  # Dictation overlay (GTK4 waveform bar)
  systemd.user.services.dictation-overlay = {
    description = "Dictation overlay (GTK4 waveform bar)";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "whisp-away-daemon.service" "ydotoold.service" ];
    serviceConfig = {
      ExecStart = "${dictation-overlay}/bin/dictation-overlay";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };
}
