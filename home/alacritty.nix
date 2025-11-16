{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.8;
        decorations = "none";
        dimensions = {
          columns = 140;
          lines = 36;
        };
        padding = {
          x = 25;
          y = 20;
        };
      };

      font = {
        size = 12;
        normal = {
          family = "Hack Nerd Font Mono";
          style = "Regular";
        };
        bold = {
          family = "Hack Nerd Font Mono";
          style = "Bold";
        };
        italic = {
          family = "Hack Nerd Font Mono";
          style = "Italic";
        };
        offset = {
          x = 0;
          y = 0;
        };
        glyph_offset = {
          x = 0;
          y = 0;
        };
      };

      colors = {
        draw_bold_text_with_bright_colors = true;
        
        primary = {
          background = "0x000000";
          foreground = "0xfbf1c7";
        };
        
        normal = {
          black = "0x282828";
          red = "0xcc241d";
          green = "0x98971a";
          yellow = "0xd79921";
          blue = "0x458588";
          magenta = "0xb16286";
          cyan = "0x689d6a";
          white = "0xa89984";
        };
        
        bright = {
          black = "0x928374";
          red = "0xfb4934";
          green = "0xb8bb26";
          yellow = "0xfabd2f";
          blue = "0x83a598";
          magenta = "0xd3869b";
          cyan = "0x8ec07c";
          white = "0xebdbb2";
        };
        
        cursor = {
          cursor = "CellForeground";
          text = "CellBackground";
        };
        
        selection = {
          background = "0xdc3232";
          text = "0xffffff";
        };
        
        indexed_colors = [
          { index = 16; color = "0xdc9656"; }
          { index = 17; color = "0xa16946"; }
          { index = 18; color = "0x282828"; }
          { index = 19; color = "0x383838"; }
          { index = 20; color = "0xb8b8b8"; }
          { index = 21; color = "0xe8e8e8"; }
        ];
      };

      cursor = {
        style = {
          shape = "Beam";
          blinking = "off";
        };
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      keyboard = {
        bindings = [
          { key = "N"; mods = "Control"; action = "SpawnNewInstance"; }
        ];
      };
    };
  };
}