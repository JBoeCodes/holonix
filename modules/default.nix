{
  imports = [
    # Config
    ./config/fonts.nix
    ./config/locale.nix
    ./config/user.nix

    # Display (conditional per-host)
    ./display/gnome.nix
    ./display/hyprland.nix

    # Hardware
    ./hardware/audio.nix
    ./hardware/nvidia.nix

    # Network
    ./network/networking.nix
    ./network/smb.nix

    # System
    ./system/boot.nix
    ./system/nix.nix
    ./system/printing.nix
    ./system/steam.nix

    # Tools
    # (empty for now)
  ];
}
