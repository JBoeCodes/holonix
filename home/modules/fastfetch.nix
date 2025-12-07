{ config, pkgs, ... }:

{
  # Fastfetch configuration
  home.file.".config/fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "logo": {
        "type": "auto",
        "padding": {
          "top": 1,
          "left": 2
        }
      },
      "display": {
        "separator": " → ",
        "color": {
          "keys": "blue",
          "title": "cyan"
        }
      },
      "modules": [
        {
          "type": "custom",
          "format": "Hello, Jameson"
        },
        {
          "type": "title",
          "format": "{user-name-colored}@{host-name-colored}"
        },
        {
          "type": "separator",
          "string": "─"
        },
        {
          "type": "os",
          "key": "OS",
          "keyColor": "blue"
        },
        {
          "type": "host",
          "key": "Host",
          "keyColor": "blue"
        },
        {
          "type": "kernel",
          "key": "Kernel",
          "keyColor": "blue"
        },
        {
          "type": "uptime",
          "key": "Uptime",
          "keyColor": "blue"
        },
        {
          "type": "packages",
          "key": "Packages",
          "keyColor": "blue"
        },
        {
          "type": "shell",
          "key": "Shell",
          "keyColor": "blue"
        },
        {
          "type": "display",
          "key": "Display",
          "keyColor": "blue"
        },
        {
          "type": "de",
          "key": "DE",
          "keyColor": "blue"
        },
        {
          "type": "wm",
          "key": "WM",
          "keyColor": "blue"
        },
        {
          "type": "wmtheme",
          "key": "Theme",
          "keyColor": "blue"
        },
        {
          "type": "terminal",
          "key": "Terminal",
          "keyColor": "blue"
        },
        {
          "type": "terminalfont",
          "key": "Font",
          "keyColor": "blue"
        },
        {
          "type": "cpu",
          "key": "CPU",
          "keyColor": "green"
        },
        {
          "type": "gpu",
          "key": "GPU",
          "keyColor": "green"
        },
        {
          "type": "memory",
          "key": "Memory",
          "keyColor": "yellow"
        },
        {
          "type": "disk",
          "key": "Disk (/)",
          "keyColor": "yellow"
        },
        {
          "type": "battery",
          "key": "Battery",
          "keyColor": "red"
        },
        {
          "type": "poweradapter",
          "key": "Power",
          "keyColor": "red"
        },
        {
          "type": "separator",
          "string": "─"
        },
        {
          "type": "colors",
          "paddingLeft": 2,
          "symbol": "circle"
        }
      ]
    }
  '';
}
