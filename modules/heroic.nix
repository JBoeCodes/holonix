{ pkgs, ... }:

{
  users.users.jboe.packages = [ pkgs.heroic ];
}
