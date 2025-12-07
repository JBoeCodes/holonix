{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;

    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      terminal = "kitty";
      drun-display-format = "{name}";
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "󰀻  Apps";
      display-run = "  Run";
      display-window = "  Windows";
      sidebar-mode = true;
      icon-theme = "Papirus-Dark";
    };

    font = "Hack Nerd Font 13";

    # Custom theme using CSS-like syntax
    theme = builtins.toFile "custom-rofi-theme.rasi" ''
      /* Import matugen-generated colors */
      @import "colors.rasi"

      * {
        /* Use matugen colors - imported from colors.rasi */
        bg0: @bg;
        bg1: @bg-alt;
        bg2: @selected;
        fg0: @fg;
        fg1: @fg;
        accent: @fg-alt;

        background-color: transparent;
        text-color: @fg0;
        margin: 0;
        padding: 0;
        spacing: 0;
      }

      window {
        background-color: @bg0;
        transparency: "real";
        border: 2px;
        border-color: @accent;
        border-radius: 12px;
        width: 600px;
        location: center;
        anchor: center;
      }

      mainbox {
        padding: 12px;
      }

      inputbar {
        background-color: @bg1;
        border-radius: 8px;
        padding: 12px 16px;
        spacing: 8px;
        children: [ prompt, entry ];
      }

      prompt {
        text-color: @accent;
        font: "Hack Nerd Font Bold 13";
      }

      entry {
        placeholder: "Search...";
        placeholder-color: @fg1;
      }

      message {
        margin: 12px 0 0;
        border-radius: 8px;
        border-color: @bg1;
        background-color: @bg1;
      }

      textbox {
        padding: 8px 12px;
      }

      listview {
        background-color: transparent;
        margin: 12px 0 0;
        lines: 8;
        columns: 1;
      }

      element {
        padding: 10px 12px;
        spacing: 12px;
        border-radius: 8px;
      }

      element normal.normal {
        text-color: @fg0;
      }

      element normal.urgent {
        text-color: @urgent;
      }

      element normal.active {
        text-color: @accent;
      }

      element selected.normal {
        background-color: @bg2;
        text-color: @accent;
      }

      element selected.urgent {
        background-color: @urgent;
        text-color: @bg0;
      }

      element selected.active {
        background-color: @bg2;
        text-color: @accent;
      }

      element-icon {
        size: 1.2em;
        vertical-align: 0.5;
      }

      element-text {
        text-color: inherit;
      }
    '';
  };
}
