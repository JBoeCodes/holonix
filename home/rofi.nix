{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "kitty";

    extraConfig = {
      modi = "drun";
      show-icons = true;
      icon-theme = "Papirus-Dark";
      drun-display-format = "{name}";
      display-drun = "Apps";
      hover-select = true;
      me-select-entry = "MouseSecondary";
      me-accept-entry = "MousePrimary";
    };

    theme = let
      inherit (builtins) toString;
      # Catppuccin Mocha palette (fallback when Wallust isn't active)
      base      = "rgba ( 30, 30, 46, 55 % )";
      surface0  = "rgba ( 49, 50, 68, 60 % )";
      text      = "rgba ( 205, 214, 244, 100 % )";
      textMuted = "rgba ( 205, 214, 244, 70 % )";
      textDim   = "rgba ( 205, 214, 244, 40 % )";
      subtle    = "rgba ( 205, 214, 244, 15 % )";
      faintBdr  = "rgba ( 205, 214, 244, 8 % )";
      tileBg    = "rgba ( 205, 214, 244, 5 % )";
    in {
      "*" = {
        background-color = "transparent";
        text-color        = text;
      };

      window = {
        transparency     = "real";
        location         = "center";
        anchor           = "center";
        fullscreen       = false;
        width            = "45%";
        border           = "1px solid";
        border-radius    = "12px";
        border-color     = subtle;
        background-color = base;
        cursor           = "default";
      };

      mainbox = {
        spacing          = "12px";
        padding          = "24px";
        background-color = "transparent";
        children         = [ "inputbar" "listview" ];
      };

      inputbar = {
        spacing          = "10px";
        padding          = "10px 14px";
        border           = "1px solid";
        border-radius    = "8px";
        border-color     = faintBdr;
        background-color = surface0;
        text-color       = text;
        children         = [ "textbox-prompt-colon" "entry" ];
      };

      textbox-prompt-colon = {
        expand           = false;
        str              = "  ";
        padding          = "4px 0px";
        background-color = "transparent";
        text-color       = textDim;
      };

      entry = {
        padding           = "4px 0px";
        background-color  = "transparent";
        text-color        = text;
        cursor            = "text";
        placeholder       = "Search...";
        placeholder-color = textDim;
      };

      listview = {
        columns      = 5;
        lines        = 4;
        cycle        = true;
        dynamic      = true;
        scrollbar    = false;
        layout       = "vertical";
        flow         = "horizontal";
        fixed-height = true;
        fixed-columns = true;
        spacing      = "8px";
        padding      = "8px 0px 0px 0px";
        background-color = "transparent";
      };

      element = {
        spacing          = "6px";
        padding          = "12px 8px";
        border           = "1px solid";
        border-radius    = "10px";
        border-color     = faintBdr;
        background-color = tileBg;
        text-color       = textMuted;
        cursor           = "pointer";
        orientation      = "vertical";
      };

      "element selected" = {
        background-color = subtle;
        text-color       = text;
        border-color     = "rgba ( 205, 214, 244, 20 % )";
      };

      element-icon = {
        background-color  = "transparent";
        text-color        = "inherit";
        size              = "48px";
        cursor            = "inherit";
        horizontal-align  = "0.5";
      };

      element-text = {
        background-color  = "transparent";
        text-color        = "inherit";
        cursor            = "inherit";
        vertical-align    = "0.5";
        horizontal-align  = "0.5";
        font              = "JetBrainsMono Nerd Font 10";
      };

      message = {
        background-color = "transparent";
      };

      textbox = {
        padding          = "12px";
        border-radius    = "8px";
        background-color = surface0;
        text-color       = text;
        vertical-align   = "0.5";
        horizontal-align = "0.5";
      };

      error-message = {
        padding          = "12px";
        border           = "1px solid";
        border-radius    = "8px";
        border-color     = subtle;
        background-color = base;
        text-color       = text;
      };
    };
  };
}
