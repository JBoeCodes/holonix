{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };

  outputs = { self, nixpkgs, nix-flatpak, ... }@inputs: {
    nixosConfigurations = {
      jboedesk = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nix-flatpak.nixosModules.nix-flatpak
          ./configuration.nix
          ./modules/1password.nix
          ./modules/audio.nix
          ./modules/boot.nix
          ./modules/desktop.nix
          ./modules/firefox.nix
          ./modules/fonts.nix
          ./modules/kitty.nix
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
          ./modules/rclone-bisync.nix
          ./modules/zsh.nix
          ./modules/hardening.nix
          ./modules/hide-desktop-entries.nix
          ./modules/default-browser.nix
          ./modules/flatpak.nix
        ];
      };
    };
  };
}
