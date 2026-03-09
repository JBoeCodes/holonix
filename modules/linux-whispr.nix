{ pkgs, ... }:

let
  linux-whispr = pkgs.python3Packages.buildPythonApplication rec {
    pname = "linux-whispr";
    version = "0.1.0";
    pyproject = true;

    src = pkgs.fetchFromGitHub {
      owner = "ferrarimb";
      repo = "linux-whispr";
      rev = "815e98d5fbc543a6544b3822342370f492b0b1e8";
      hash = "sha256-9T20a41Vp12QMc//T1SJjj0F2QxK6HFRAjsk8FhMjk0=";
    };

    build-system = [ pkgs.python3Packages.hatchling ];

    postPatch = ''
      # GNOME Wayland: no GlobalShortcuts portal, and XGrabKey fails via XWayland.
      # Skip both and go straight to pynput on GNOME.
      substituteInPlace src/linux_whispr/input/hotkey.py \
        --replace-fail \
          'if platform.display_server == DisplayServer.WAYLAND:' \
          'if platform.display_server == DisplayServer.WAYLAND and "gnome" not in __import__("os").environ.get("XDG_CURRENT_DESKTOP", "").lower():'
      substituteInPlace src/linux_whispr/input/hotkey.py \
        --replace-fail \
          'if platform.display_server in (DisplayServer.X11, DisplayServer.WAYLAND):' \
          'if platform.display_server in (DisplayServer.X11, DisplayServer.WAYLAND) and "gnome" not in __import__("os").environ.get("XDG_CURRENT_DESKTOP", "").lower():'
    '';

    nativeBuildInputs = [
      pkgs.wrapGAppsHook4
      pkgs.gobject-introspection
    ];

    dependencies = with pkgs.python3Packages; [
      sounddevice
      numpy
      faster-whisper
      onnxruntime
      tomli-w
      pynput
      rich
      pygobject3
      pystray
      dbus-python
    ];

    buildInputs = [
      pkgs.gtk4
      pkgs.gtk4-layer-shell
      pkgs.libadwaita
      pkgs.portaudio
    ];

    makeWrapperArgs = [
      "--prefix" "PATH" ":" (pkgs.lib.makeBinPath [
        pkgs.wl-clipboard
        pkgs.xdotool
        pkgs.xclip
      ])
      "--set" "LD_PRELOAD" "${pkgs.gtk4-layer-shell}/lib/libgtk4-layer-shell.so"
    ];

    dontWrapGApps = true;

    preFixup = ''
      makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    '';

    doCheck = false;

    meta = with pkgs.lib; {
      description = "Privacy-first voice dictation for Linux";
      homepage = "https://github.com/ferrarimb/linux-whispr";
      license = licenses.mit;
      mainProgram = "linux-whispr";
      platforms = platforms.linux;
    };
  };
in
{
  users.users.jboe.packages = [ linux-whispr ];
}
