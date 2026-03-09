{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    whisp-away.url = "github:madjinn/whisp-away";
  };

  outputs = { self, nixpkgs, whisp-away, ... }@inputs: {
    nixosConfigurations = {
      jboedesk = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit whisp-away; };
        modules = [
          ./configuration.nix
          ./modules/1password.nix
          ./modules/audio.nix
          ./modules/boot.nix
          ./modules/desktop.nix
          ./modules/firefox.nix
          ./modules/ghostty.nix
          ./modules/dictation.nix
          ./modules/keyboard.nix
          ./modules/locale.nix
          ./modules/networking.nix
          ./modules/nvidia.nix
          ./modules/packages.nix
          ./modules/steam.nix
          ./modules/user.nix
          ./modules/zsh.nix
        ];
      };
    };
  };
}
