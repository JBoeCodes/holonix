{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "sudo"
        "history-substring-search"
        "colored-man-pages"
        "command-not-found"
      ];
    };
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      l = "ls -CF";
      ".." = "cd ..";
      "..." = "cd ../..";
      grep = "grep --color=auto";
      nixos-rebuild = "sudo nixos-rebuild";
      nix-search = "nix search nixpkgs";
    };
    
    initContent = ''
      # Custom zsh configuration
      setopt AUTO_CD
      setopt HIST_VERIFY
      setopt SHARE_HISTORY
      setopt APPEND_HISTORY
      
      # Better history search
      bindkey '^R' history-incremental-search-backward
      
      # NixOS specific aliases
      alias nrs="sudo nixos-rebuild switch --flake .#jboedesk"
      alias nrt="sudo nixos-rebuild test --flake .#jboedesk"
      alias nrb="sudo nixos-rebuild boot --flake .#jboedesk"
      alias nfu="nix flake update"
      alias nfc="nix flake check"
    '';
  };
}