{ ... }:
{
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        grace = 1;
      };

      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_size = 4;
          blur_passes = 3;
          noise = 0.0117;
          contrast = 1.3;
          brightness = 0.7;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "300, 80";
          outline_thickness = 3;
          dots_size = 0.33;
          dots_spacing = 0.15;
          dots_center = true;
          outer_color = "rgb(c4a7e7)";
          inner_color = "rgb(1f1d2e)";
          font_color = "rgb(e0def4)";
          check_color = "rgb(f6c177)";
          fail_color = "rgb(eb6f92)";
          fade_on_empty = true;
          placeholder_text = "<i>Password...</i>";
          hide_input = false;
          rounding = 12;
          position = "0, -50";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        # Time
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +\"%I:%M %p\")\"";
          font_size = 120;
          font_family = "JetBrainsMono Nerd Font ExtraBold";
          color = "rgb(e0def4)";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
        # Date
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +\"%A, %B %d\")\"";
          font_size = 24;
          font_family = "JetBrainsMono Nerd Font";
          color = "rgb(908caa)";
          position = "0, 100";
          halign = "center";
          valign = "center";
        }
        # User
        {
          monitor = "";
          text = "Hi, $USER";
          font_size = 18;
          font_family = "JetBrainsMono Nerd Font";
          color = "rgb(ebbcba)";
          position = "0, -150";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
