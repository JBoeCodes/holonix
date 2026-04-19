{
  lib,
  stdenv,
  bzip2,
  callPackage,
  fetchzip,
  fontconfig,
  freetype,
  glib,
  glslang,
  gtk4-layer-shell,
  harfbuzz,
  libadwaita,
  libGL,
  libx11,
  libxml2,
  ncurses,
  oniguruma,
  pandoc,
  pkg-config,
  removeReferencesTo,
  wrapGAppsHook4,
  blueprint-compiler,
  zig_0_15,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ghostty-embedded";
  version = "1.3.2-unstable-2026-03-27";

  # github.com/.../archive/<sha>.tar.gz is currently returning 504 for this
  # commit; use the codeload tarball endpoint directly.
  src = fetchzip {
    url = "https://codeload.github.com/patcito/ghostty/tar.gz/318afb82281e79b03acb6a6ca88dc08e8cb87d2f";
    hash = "sha256-JgTnwTQANkMpHTbVQrdSNDjSnU0QCBV7ZWq4zqESytA=";
    extension = "tar.gz";
  };

  deps = callPackage ./deps.nix {
    name = "${finalAttrs.pname}-cache-${finalAttrs.version}";
  };

  strictDeps = true;

  nativeBuildInputs = [
    ncurses
    pandoc
    pkg-config
    removeReferencesTo
    zig_0_15
    glib
    wrapGAppsHook4
    blueprint-compiler
    libxml2
  ];

  buildInputs = [
    oniguruma
    libadwaita
    libx11
    gtk4-layer-shell
    glslang
    libGL
    bzip2
    fontconfig
    freetype
    harfbuzz
  ];

  dontSetZigDefaultFlags = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
    "-Dapp-runtime=none"
    "-Doptimize=ReleaseFast"
    "-Dcpu=baseline"
    "-Dversion-string=${finalAttrs.version}"
  ]
  ++ lib.mapAttrsToList (name: package: "-fsys=${name} --search-prefix ${lib.getLib package}") {
    inherit glslang;
  };

  doCheck = false;

  # PrettyMux's meson.build expects a specific in-tree layout pointed at by
  # -Dghostty_dir=...:
  #   $ghostty_dir/include/ghostty.h
  #   $ghostty_dir/zig-out/lib/libghostty.so
  #   $ghostty_dir/vendor/glad/{include,src/gl.c}
  # We synthesise that layout in $out.
  postInstall = ''
    mkdir -p $out/zig-out/lib $out/vendor
    if [ -f $out/lib/libghostty.so ]; then
      cp -P $out/lib/libghostty.so* $out/zig-out/lib/
    fi
    if [ -f $out/lib/libghostty.a ]; then
      cp $out/lib/libghostty.a $out/zig-out/lib/
    fi
    cp -r vendor/glad $out/vendor/glad

    remove-references-to -t ${finalAttrs.deps} $out/zig-out/lib/libghostty.so || true
  '';

  meta = {
    description = "Ghostty terminal engine built as embeddable library (patcito fork for PrettyMux)";
    homepage = "https://github.com/patcito/ghostty/tree/linux-embedded-platform";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
