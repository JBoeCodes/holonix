{ inputs, pkgs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };

    users.jboe = {
      home.username = "jboe";
      home.homeDirectory = "/home/jboe";
      home.stateVersion = "25.05";

      imports = [
        ../home/hyprland.nix
        ../home/waybar.nix
        ../home/rofi.nix
        ../home/swaync.nix
        ../home/wlogout.nix
        ../home/hyprlock.nix
        ../home/hypridle.nix
        ../home/kitty.nix
        ../home/gtk.nix
        ../home/scripts.nix
      ];
    };
  };
}
