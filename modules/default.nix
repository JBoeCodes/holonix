{
  imports = [
    # Config
    ./config/locale.nix
    ./config/user.nix

    # Display
    ./display/kde-plasma.nix

    # Hardware
    ./hardware/audio.nix
    ./hardware/nvidia.nix

    # Network
    ./network/networking.nix

    # System
    ./system/boot.nix
    ./system/nix.nix
    ./system/steam.nix
    ./system/storage.nix
  ];
}