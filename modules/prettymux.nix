{ config, lib, pkgs, ... }:

let
  cfg = config.programs.prettymux;
in {
  options.programs.prettymux = {
    enable = lib.mkEnableOption "PrettyMux (GTK4 terminal multiplexer with embedded browser, Cmux analogue)";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.prettymux ];
  };
}
