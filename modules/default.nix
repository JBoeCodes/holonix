{
  imports = [
    # Config
    ./config/fonts.nix
    ./config/locale.nix
    ./config/user.nix

    # Display (conditional per-host)
    ./display/gnome.nix
    ./display/kde-plasma.nix

    # Hardware
    ./hardware/amd-graphics.nix
    ./hardware/alvr.nix
    ./hardware/audio.nix
    ./hardware/imac-2015.nix
    ./hardware/intel-graphics.nix
    ./hardware/laptop-power.nix
    ./hardware/nvidia.nix
    ./hardware/vr.nix

    # Network
    ./network/networking.nix
    ./network/smb.nix

    # Packages
    ./packages/system-tools.nix

    # System
    ./system/boot.nix
    ./system/safe-boot-optimization.nix
    ./system/insecure-packages.nix
    ./system/nix.nix
    ./system/printing.nix
    ./system/steam.nix
    ./system/storage.nix

    # Tools
    ./tools/git-repos.nix
  ];
}
