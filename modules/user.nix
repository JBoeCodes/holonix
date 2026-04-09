{ ... }:

{
  users.users.jboe = {
    isNormalUser = true;
    description = "jboe";
    extraGroups = [ "networkmanager" "wheel" "input" ];
  };

  security.sudo.wheelNeedsPassword = false;
}
