{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  binutils,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  adwaita-icon-theme,
  gsettings-desktop-schemas,
  gtk3,
  gtk4,
  qt6,
  libx11,
  libxscrnsaver,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxrandr,
  libxrender,
  libxtst,
  libdrm,
  libkrb5,
  libuuid,
  libxkbcommon,
  libxshmfence,
  libgbm,
  nspr,
  nss,
  pango,
  pipewire,
  snappy,
  udev,
  wayland,
  xdg-utils,
  coreutils,
  libxcb,
  zlib,
  libpulseaudio,
  libGL,
  libva,
}:

let
  pname = "brave-origin-nightly";
  version = "1.91.113";

  deps = [
    alsa-lib at-spi2-atk at-spi2-core atk cairo cups dbus expat fontconfig
    freetype gdk-pixbuf glib gtk3 gtk4 libdrm libx11 libGL libxkbcommon
    libxscrnsaver libxcomposite libxcursor libxdamage libxext libxfixes libxi
    libxrandr libxrender libxshmfence libxtst libuuid libgbm nspr nss pango
    pipewire udev wayland libxcb zlib snappy libkrb5 qt6.qtbase libpulseaudio
    libva
  ];

  rpath = lib.makeLibraryPath deps + ":" + lib.makeSearchPathOutput "lib" "lib64" deps;
  binpath = lib.makeBinPath deps;
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-origin-nightly_${version}_amd64.deb";
    sha256 = "1zhphm37j03mh0rzs56rgsh7lfnxx969mi4dz5qhq6ql12xiqyn5";
  };

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;

  nativeBuildInputs = [
    binutils
    (buildPackages.wrapGAppsHook3.override { makeWrapper = buildPackages.makeShellWrapper; })
  ];

  buildInputs = [
    glib
    gsettings-desktop-schemas
    gtk3
    gtk4
    adwaita-icon-theme
  ];

  unpackPhase = ''
    runHook preUnpack
    ar x $src
    tar --no-same-permissions --no-same-owner -xf data.tar.xz
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out $out/bin

    cp -R usr/share $out
    cp -R opt $out/opt

    OPTDIR=$out/opt/brave.com/brave-origin-nightly
    BINARYWRAPPER=$OPTDIR/brave-origin-nightly

    substituteInPlace $BINARYWRAPPER \
        --replace-fail /bin/bash ${stdenv.shell} \
        --replace-fail 'CHROME_WRAPPER' 'WRAPPER'

    ln -sf $BINARYWRAPPER $out/bin/brave-origin-nightly

    for exe in $OPTDIR/brave $OPTDIR/chrome_crashpad_handler; do
        patchelf \
            --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
            --set-rpath "${rpath}" $exe
    done

    # Fix paths in desktop files
    for desk in $out/share/applications/*.desktop; do
      substituteInPlace $desk \
        --replace-fail /usr/bin/brave-origin-nightly $out/bin/brave-origin-nightly
    done

    substituteInPlace $out/share/gnome-control-center/default-apps/brave-origin-nightly.xml \
        --replace-fail /opt/brave.com $out/opt/brave.com
    substituteInPlace $OPTDIR/default-app-block \
        --replace-fail /opt/brave.com $out/opt/brave.com

    # Icons
    for icon in 16 24 32 48 64 128 256; do
        mkdir -p $out/share/icons/hicolor/''${icon}x''${icon}/apps
        ln -s $OPTDIR/product_logo_$icon.png \
              $out/share/icons/hicolor/''${icon}x''${icon}/apps/brave-origin-nightly.png
    done

    # Replace bundled xdg utilities with the system ones
    ln -sf ${xdg-utils}/bin/xdg-settings $OPTDIR/xdg-settings
    ln -sf ${xdg-utils}/bin/xdg-mime $OPTDIR/xdg-mime

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${rpath}
      --prefix PATH : ${binpath}
      --suffix PATH : ${lib.makeBinPath [ xdg-utils coreutils ]}
      --set CHROME_WRAPPER ${pname}
      --add-flags "--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+,WaylandWindowDecorations --enable-wayland-ime=true}}"
      --add-flags "--disable-features=OutdatedBuildDetector,UseChromeOSDirectVideoDecoder"
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto}}"
    )
  '';

  meta = {
    homepage = "https://brave.com/origin/";
    description = "Minimalist, paid version of Brave (free on Linux) with core privacy features and no Rewards/VPN/Wallet/Leo";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    mainProgram = "brave-origin-nightly";
  };
}
