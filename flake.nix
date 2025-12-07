{
  description = "NixOS Configuration for jboedesk, jboebook, nixpad, and jboeimac";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    matugen.url = "github:InioX/matugen";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, matugen, ... }@inputs: 
  let
    pkgs-unstable = import nixpkgs-unstable {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
  in
  {
    nixosConfigurations.jboedesk = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { 
        inherit inputs pkgs-unstable;
      };
      modules = [
        ./hosts/jboedesk/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.jboe = import ./home/home.nix;
          home-manager.extraSpecialArgs = { 
            inherit inputs pkgs-unstable;
          };
        }
      ];
    };
    
    nixosConfigurations.jboebook = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { 
        inherit inputs pkgs-unstable;
      };
      modules = [
        ./hosts/jboebook/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.jboe = import ./home/home.nix;
          home-manager.extraSpecialArgs = { 
            inherit inputs pkgs-unstable;
          };
        }
      ];
    };
    
    nixosConfigurations.nixpad = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { 
        inherit inputs pkgs-unstable;
      };
      modules = [
        ./hosts/nixpad/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.jboe = import ./home/home.nix;
          home-manager.extraSpecialArgs = { 
            inherit inputs pkgs-unstable;
          };
        }
      ];
    };
    
    nixosConfigurations.jboeimac = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { 
        inherit inputs pkgs-unstable;
      };
      modules = [
        ./hosts/jboeimac/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.jboe = import ./home/home.nix;
          home-manager.extraSpecialArgs = { 
            inherit inputs pkgs-unstable;
          };
        }
      ];
    };
  };
}