{ ... }:

{
  networking.hostName = "jboedesk";
  networking.networkmanager.enable = true;

  networking.firewall.allowedTCPPorts = [ 53317 ];
  networking.firewall.allowedUDPPorts = [ 53317 ];
}
