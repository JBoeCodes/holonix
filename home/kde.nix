{ config, lib, ... }:

{
  # Declaratively manage KDE keyboard shortcuts via configuration files
  home.file = {
    # Global shortcuts configuration
    ".config/kglobalshortcutsrc".text = ''
      [kwin]
      Switch to Desktop 1=Meta+1,Meta+F1,Switch to Desktop 1
      Switch to Desktop 2=Meta+2,Meta+F2,Switch to Desktop 2
      Switch to Desktop 3=Meta+3,Meta+F3,Switch to Desktop 3
      Switch to Desktop 4=Meta+4,Meta+F4,Switch to Desktop 4
      Window to Desktop 1=Meta+!,none,Window to Desktop 1
      Window to Desktop 2=Meta+@,none,Window to Desktop 2
      Window to Desktop 3=Meta+#,none,Window to Desktop 3
      Window to Desktop 4=Meta+$,none,Window to Desktop 4
      Window Quick Tile Left=Meta+Left,Meta+Left,Quick Tile Window to the Left
      Window Quick Tile Right=Meta+Right,Meta+Right,Quick Tile Window to the Right
      Window Maximize=Meta+Up,Meta+PgUp,Maximize Window
      Window Minimize=Meta+Down,Meta+PgDown,Minimize Window
      Window Close=Meta+Q,Alt+F4,Close Window
      Show Desktop=Meta+D,Meta+D,Peek at Desktop
      
      [org.kde.konsole.desktop]
      _launch=Meta+Return,none,Launch Konsole
      
      [org.kde.dolphin.desktop]
      _launch=Meta+E,none,Launch Dolphin
      
      [plasmashell]
      activate application launcher=Meta+Space,Alt+F1,Activate Application Launcher
      show dashboard=Meta+A,none,Show Dashboard
    '';
    
    # Additional KDE shortcuts configuration
    ".config/khotkeysrc".text = ''
      [Data]
      DataCount=0
      
      [Main]
      AlreadyImported=defaults,kde32b1,konqueror_gestures_kde321
      Disabled=false
      Version=2
    '';
  };
}