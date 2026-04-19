final: prev: {
  ghostty-embedded = final.callPackage ./ghostty-embedded.nix { };
  prettymux = final.callPackage ./prettymux.nix { };
}
