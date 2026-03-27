{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    whisp-overlay.url = "github:JBoeCodes/whisp-overlay";
  };

  outputs = { self, nixpkgs, whisp-overlay, ... }@inputs: {
    nixosConfigurations = {
      jboedesk = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
./configuration.nix
          ./modules/1password.nix
          ./modules/audio.nix
          ./modules/boot.nix
          ./modules/desktop.nix
          ./modules/firefox.nix
          ./modules/fonts.nix
          ./modules/ghostty.nix
          ./modules/hyprland.nix
          whisp-overlay.nixosModules.default
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
