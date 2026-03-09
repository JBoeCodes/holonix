{ pkgs, whisp-away, ... }:

let
  whispAwayPkg = whisp-away.packages.x86_64-linux.default;

  python = pkgs.python3.withPackages (ps: [
    ps.pygobject3
    ps.numpy
    ps.sounddevice
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

  whisp-away-launcher = pkgs.writeShellScriptBin "whisp-away-launcher" ''
    # Detect available VRAM (NVIDIA) or fall back to system RAM
    VRAM_MB=0
    if command -v nvidia-smi &>/dev/null; then
      VRAM_MB=$(nvidia-smi --query-gpu=memory.free --format=csv,noheader,nounits 2>/dev/null | head -1 | tr -d ' ')
    fi
    if [ "$VRAM_MB" -eq 0 ] 2>/dev/null; then
      # Fall back to system RAM
      VRAM_MB=$(${pkgs.gawk}/bin/awk '/MemAvailable/ {printf "%d", $2/1024}' /proc/meminfo)
    fi

    # Select best model that fits comfortably in available memory
    # Model VRAM requirements (approximate, including whisper.cpp overhead):
    #   large-v3:  ~3000 MB    medium.en: ~1500 MB
    #   small.en:  ~600 MB     base.en:   ~300 MB
    #   tiny.en:   ~200 MB
    if [ "$VRAM_MB" -ge 4000 ]; then
      MODEL="large-v3"
    elif [ "$VRAM_MB" -ge 2000 ]; then
      MODEL="medium.en"
    elif [ "$VRAM_MB" -ge 800 ]; then
      MODEL="small.en"
    elif [ "$VRAM_MB" -ge 400 ]; then
      MODEL="base.en"
    else
      MODEL="tiny.en"
    fi

    echo "Detected ''${VRAM_MB}MB available, selecting model: $MODEL"

    # Download model if not cached
    ${whispAwayPkg}/bin/download-whisper-model "$MODEL"

    # Start daemon with selected model
    exec ${whispAwayPkg}/bin/whisp-away daemon --backend whisper-cpp --model "$MODEL"
  '';

  dictate = pkgs.writeShellScriptBin "dictate" ''
    ${pkgs.glib}/bin/gdbus call --session \
      --dest=com.jboe.Dictation \
      --object-path /com/jboe/Dictation \
      --method org.freedesktop.Application.ActivateAction \
      toggle '[]' '{}'
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
      ExecStart = "${whisp-away-launcher}/bin/whisp-away-launcher";
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
    after = [ "whisp-away-daemon.service" "ydotoold.service" "gnome-session-initialized.target" ];
    serviceConfig = {
      ExecStart = "${dictation-overlay}/bin/dictation-overlay";
      Restart = "always";
      RestartSec = 3;
    };
  };
}
