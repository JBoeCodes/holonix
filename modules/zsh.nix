{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    shellAliases = {
      cx = "claude --dangerously-skip-permissions";
      cc = "claude";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos#jboedesk";
    };
  };

  users.users.jboe.shell = pkgs.zsh;
}
