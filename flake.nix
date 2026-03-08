{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      jboedesk = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./modules/audio.nix
          ./modules/boot.nix
          ./modules/desktop.nix
          ./modules/ghostty.nix
          ./modules/keyboard.nix
          ./modules/locale.nix
          ./modules/networking.nix
          ./modules/nvidia.nix
          ./modules/packages.nix
          ./modules/user.nix
          ./modules/zsh.nix
        ];
      };
    };
  };
}
