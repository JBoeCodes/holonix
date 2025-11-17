{
  imports = [
    # Config
    ./config/fonts.nix
    ./config/locale.nix
    ./config/user.nix

    # Hardware
    ./hardware/alvr.nix
    ./hardware/audio.nix
    ./hardware/nvidia.nix
    ./hardware/vr.nix

    # Network
    ./network/networking.nix

    # System
    ./system/boot.nix
    ./system/nix.nix
    ./system/steam.nix
    ./system/storage.nix

    # Tools
    ./tools/git-repos.nix
  ];
}
