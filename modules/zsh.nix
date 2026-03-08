{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    shellAliases = {
      cx = "claude --dangerously-skip-permissions";
      cc = "claude";
    };
  };

  users.users.jboe.shell = pkgs.zsh;
}
