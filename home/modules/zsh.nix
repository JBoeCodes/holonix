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

    # NixOS-specific completions
    plugins = [
      {
        name = "nix-zsh-completions";
        src = pkgs.nix-zsh-completions;
        file = "share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh";
      }
    ];
    
    shellAliases = {
      # Modern CLI tool aliases
      ls = "eza --icons";
      ll = "eza -l --icons";
      la = "eza -la --icons";
      l = "eza -CF --icons";
      tree = "eza --tree --icons";
      cat = "bat";
      find = "fd";
      cd = "z";
      
      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      
      # System monitoring
      htop = "btop";
      neofetch = "fastfetch";
      
      # Utilities
      grep = "grep --color=auto";
      nixos-rebuild = "sudo nixos-rebuild";
      nix-search = "nix search nixpkgs";
      
      # AI-assisted NixOS config editing
      nixai = "cd ~/nixos && claude";
    };
    
    initContent = ''
      # Custom zsh configuration
      setopt AUTO_CD
      setopt HIST_VERIFY
      setopt SHARE_HISTORY
      setopt APPEND_HISTORY

      # Better history search
      bindkey '^R' history-incremental-search-backward

      # Initialize zoxide
      eval "$(zoxide init zsh)"

      # NixOS specific aliases (dynamic based on hostname)
      NIXOS_HOST=$(hostname)
      alias nrs="sudo nixos-rebuild switch --flake .#$NIXOS_HOST"
      alias nrt="sudo nixos-rebuild test --flake .#$NIXOS_HOST"
      alias nrb="sudo nixos-rebuild boot --flake .#$NIXOS_HOST"
      alias nfu="nix flake update"
      alias nfc="nix flake check"

      # Run fastfetch on shell startup
      if [[ -o interactive ]]; then
        fastfetch
      fi
    '';
  };
}