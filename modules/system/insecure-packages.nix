{ config, pkgs, ... }:

{
  # Allow specific insecure packages that are needed
  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.07"
  ];
}