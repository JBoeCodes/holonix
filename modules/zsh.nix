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
      find = "fd";
      df = "duf";
      oc = "opencode";
      lg = "lazygit";
    };
    interactiveShellInit = ''
      eval "$(zoxide init zsh)"
      export GEMINI_API_KEY="$(op read 'op://Personal/Gemini JboeDesk/credential' 2>/dev/null)"
    '';
  };

  users.users.jboe.shell = pkgs.zsh;
}
