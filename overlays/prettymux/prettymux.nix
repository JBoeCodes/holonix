{
  lib,
  stdenv,
  fetchzip,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  gtk4,
  libadwaita,
  webkitgtk_6_0,
  json-glib,
  glib,
  ghostty-embedded,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "prettymux";
  version = "0.2.28-unstable-2026-04-14";

  src = fetchzip {
    url = "https://codeload.github.com/patcito/prettymux/tar.gz/1f6cbbc52d3209bc26630dbf29b5743bad15865b";
    hash = "sha256-FIasrDYXdkbTWUv+sQougcu96WDY/bJ61fT+t3Ufvpg=";
    extension = "tar.gz";
  };

  strictDeps = true;

  sourceRoot = "${finalAttrs.src.name}/src/gtk";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    glib
  ];

  buildInputs = [
    gtk4
    libadwaita
    webkitgtk_6_0
    json-glib
    ghostty-embedded
  ];

  mesonFlags = [
    "-Dghostty_dir=${ghostty-embedded}"
  ];

  # The upstream install_rpath points at $ORIGIN/../lib/prettymux. We ship
  # libghostty.so via ghostty-embedded's store path, so patch rpath to find it.
  postFixup = ''
    patchelf --set-rpath "${lib.makeLibraryPath [ ghostty-embedded ]}:$(patchelf --print-rpath $out/bin/prettymux)" $out/bin/prettymux
  '';

  meta = {
    description = "Native Linux terminal multiplexer with GTK4, embedded WebKit browser, and Ghostty core";
    longDescription = ''
      PrettyMux is a GTK4 + libadwaita + WebKit + Ghostty terminal multiplexer
      inspired by Cmux. Features vertical tabs, split panes, workspaces, a
      built-in browser pane, agent-friendly notifications, and a
      prettymux-open CLI for scripting a running instance.
    '';
    homepage = "https://github.com/patcito/prettymux";
    license = lib.licenses.gpl3Only;
    mainProgram = "prettymux";
    platforms = lib.platforms.linux;
  };
})
