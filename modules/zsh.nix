{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
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
      df = "duf";
      oc = "opencode";
      lg = "lazygit";
      cd = "z";
    };
    interactiveShellInit = ''
      eval "$(zoxide init zsh)"
    '';
  };

  # Prevent zsh-newuser-install prompt by ensuring ~/.zshrc exists
  system.activationScripts.zshrc = ''
    if [ ! -f /home/jboe/.zshrc ]; then
      echo "# Managed by NixOS - see modules/zsh.nix" > /home/jboe/.zshrc
      chown jboe:users /home/jboe/.zshrc
    fi
  '';

  users.users.jboe.shell = pkgs.zsh;
}
