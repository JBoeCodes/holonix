{
  description = "Zen Browser - A calmer internet experience";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system} = {
        zen-browser = pkgs.callPackage ./zen-browser.nix { };
        default = self.packages.${system}.zen-browser;
      };

      apps.${system} = {
        zen-browser = {
          type = "app";
          program = "${self.packages.${system}.zen-browser}/bin/zen-browser";
        };
        default = self.apps.${system}.zen-browser;
      };
    };
}