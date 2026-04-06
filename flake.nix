{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
  };

  outputs = { self, nixpkgs, nix-flatpak, home-manager, stylix, ... }@inputs: {
    nixosConfigurations = {
      jboedesk = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          nix-flatpak.nixosModules.nix-flatpak
          ./configuration.nix
          ./modules/1password.nix
          ./modules/audio.nix
          ./modules/boot.nix
          ./modules/sddm.nix
          ./modules/stylix.nix
          ./modules/home.nix
          ./modules/firefox.nix
          ./modules/fonts.nix
          ./modules/hyprland.nix
          ./modules/keyboard.nix
          ./modules/locale.nix
          ./modules/networking.nix
          ./modules/fans.nix
          ./modules/ntsync.nix
          ./modules/nvidia.nix
          ./modules/packages.nix
          ./modules/steam.nix
          ./modules/user.nix
          ./modules/zsh.nix
          ./modules/hardening.nix
          ./modules/hide-desktop-entries.nix
          ./modules/default-browser.nix
          ./modules/flatpak.nix
          ./modules/ollama.nix
        ];
      };
    };
  };
}
