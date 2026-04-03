{ ... }:
{
  programs.wlogout = {
    enable = true;

    layout = [
      {
        label = "lock";
        action = "loginctl lock-session";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit 0";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
    ];

    style = ''
      window {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 24pt;
      }
      button {
        border-radius: 80px;
        margin: 12px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 40%;
      }
      button:hover {
        background-size: 50%;
      }
    '';
  };
}
