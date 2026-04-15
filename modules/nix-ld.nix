{ pkgs, ... }:

# Enable nix-ld so dynamically-linked binaries from outside the Nix store
# (uv's managed Pythons, various language servers, vendor-shipped CLIs)
# can find a usable ld-linux and the common libraries they expect.
#
# Without this, tools like `uv sync` fail on NixOS because uv downloads
# a generic-Linux Python build that can't locate its dynamic linker.
#
# Library set covers the common needs of Python, Node, Go, Rust, and
# language servers. Expand as needed if a specific tool fails with a
# missing-library error.

{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      openssl
      glib
      gmp
      icu
      libffi
      libxcrypt
      ncurses
      nspr
      nss
      sqlite
      expat
      bzip2
      xz
      readline
    ];
  };
}
