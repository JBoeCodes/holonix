{ lib, stdenv, fetchurl, appimageTools, makeWrapper, glib, gtk3, gsettings-desktop-schemas }:

appimageTools.wrapType2 {
  pname = "zen-browser";
  version = "1.17.6b";

  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/1.17.6b/zen-x86_64.AppImage";
    sha256 = "909e6c3c5c8e92eeea9281873e5e3fd7c96c43ff1153a74b7814b29230c9b05e";
  };

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cat > $out/share/applications/zen-browser.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Zen Browser
Comment=A calmer internet experience - Firefox-based browser
Exec=$out/bin/zen-browser
Icon=zen-browser
Terminal=false
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/vnd.mozilla.xul+xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;x-scheme-handler/chrome;video/webm;application/x-xpinstall;
StartupNotify=true
EOF
  '';

  meta = with lib; {
    description = "A calmer internet experience - Firefox-based browser with vertical tabs and workspaces";
    homepage = "https://zen-browser.app";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}