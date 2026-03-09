{ ... }:

{
  users.users.jboe = {
    isNormalUser = true;
    description = "jboe";
    extraGroups = [ "networkmanager" "wheel" "input" ];
  };
}
