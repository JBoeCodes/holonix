# Pin claude-code to a newer version than what's in nixpkgs.
# To update:
#   1. Change `version` below
#   2. Run: nix-prefetch-url --unpack "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-<VERSION>.tgz"
#      then: nix hash convert --hash-algo sha256 --to sri <hash>
#      → update `hash`
#   3. Download tarball, extract, run `npm install --package-lock-only`
#      → replace overlays/claude-code-package-lock.json
#   4. Run: nix build nixpkgs#prefetch-npm-deps --no-link --print-out-paths
#      then: <path>/bin/prefetch-npm-deps overlays/claude-code-package-lock.json
#      → update `npmDepsHash`
final: prev:
let
  version = "2.1.111";
  src = final.fetchzip {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
    hash = "sha256-K3qhZXVJ2DIKv7YL9f/CHkuUYnK0lkIR1wjEa+xeSCk=";
  };
  packageLock = ./claude-code-package-lock.json;
  npmDepsHash = "sha256-6f68qUMnDk6tn+qypVi8bPtNrxbtcf15tHrgtlhEaK4=";
in {
  claude-code = prev.claude-code.overrideAttrs (old: {
    inherit version src npmDepsHash;
    # overrideAttrs doesn't propagate to the internal fetchNpmDeps call,
    # so we must rebuild npmDeps explicitly with our lock file and source.
    npmDeps = final.fetchNpmDeps {
      name = "claude-code-${version}-npm-deps";
      inherit src;
      postPatch = "cp ${packageLock} package-lock.json";
      hash = npmDepsHash;
    };
    postPatch = ''
      cp ${packageLock} package-lock.json
      substituteInPlace cli.js \
        --replace-fail '#!/bin/sh' '#!/usr/bin/env sh'
    '';
  });
}
