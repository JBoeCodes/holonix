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
    ];

    buildInputs = [
      pkgs.gtk4
      pkgs.libadwaita
      pkgs.portaudio
    ];

    makeWrapperArgs = [
      "--prefix" "PATH" ":" (pkgs.lib.makeBinPath [
        pkgs.wl-clipboard
        pkgs.xdotool
        pkgs.xclip
      ])
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
