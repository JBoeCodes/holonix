{ pkgs, ... }:

{
  users.users.jboe.packages = [
    pkgs.cider-2
  ];
}
