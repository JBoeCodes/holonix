{
  imports = [
    # Config
    ./config/fonts.nix
    ./config/locale.nix
    ./config/user.nix

    # Display
    ./display/kde-plasma.nix
    #./display/gnome.nix

    # Hardware
    ./hardware/audio.nix

    # Network
    ./network/networking.nix
    ./network/smb.nix

    # System
    ./system/boot.nix
    ./system/nix.nix
    ./system/steam.nix
    ./system/storage.nix

    # Tools
    ./tools/git-repos.nix
  ];
}
