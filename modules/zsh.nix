{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    shellAliases = {
      cx = "claude --dangerously-skip-permissions";
      cc = "claude";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos#jboedesk";
      ls = "eza --icons";
      ll = "eza --icons -l";
      la = "eza --icons -la";
      lt = "eza --icons --tree";
      cat = "bat";
      grep = "rg";
      find = "fd";
      df = "duf";
      lg = "lazygit";
    };
    interactiveShellInit = ''
      eval "$(zoxide init zsh)"
    '';
  };

  users.users.jboe.shell = pkgs.zsh;
}
