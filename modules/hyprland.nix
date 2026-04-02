{ pkgs, ... }:

let
  dotfilesSrc = builtins.path { path = ../dotfiles; name = "kooldots-config"; };
in
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # Hyprland ecosystem packages
  users.users.jboe.packages = with pkgs; [
    # Core Hyprland ecosystem
    waybar
    rofi
    swaynotificationcenter
    libnotify
    swww
    hyprlock
    hypridle
    hyprpolkitagent
    hyprpicker
    hyprsunset
    wl-clipboard
    cliphist
    networkmanagerapplet
    networkmanager_dmenu
    wlogout

    # Screenshot / recording
    grimblast
    satty
    slurp
    wf-recorder

    # Wallust (dynamic color engine)
    wallust

    # Audio / media
    pavucontrol
    playerctl
    cava

    # Bluetooth
    blueman

    # File manager
    xfce.thunar

    # Wallpaper GUI
    waypaper

    # Gaming overlay
    mangohud

    # Qt theming
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    kdePackages.qt6ct

    # Utilities used by KoolDots scripts
    jq
    bc
    socat
    imagemagick
    yad
  ];

  # Deploy KoolDots dotfiles via activation script
  system.activationScripts.hyprlandConfig = ''
    configDir="/home/jboe/.config"

    # Create all target directories
    mkdir -p "$configDir/hypr/scripts" \
             "$configDir/hypr/UserScripts" \
             "$configDir/hypr/configs" \
             "$configDir/hypr/UserConfigs" \
             "$configDir/hypr/animations" \
             "$configDir/hypr/wallust" \
             "$configDir/hypr/wallpaper_effects" \
             "$configDir/hypr/Monitor_Profiles" \
             "$configDir/waybar/configs" \
             "$configDir/waybar/style" \
             "$configDir/waybar/wallust" \
             "$configDir/rofi/themes" \
             "$configDir/rofi/wallust" \
             "$configDir/swaync" \
             "$configDir/wlogout/icons" \
             "$configDir/wallust/templates" \
             "$configDir/kitty" \
             "$configDir/btop/themes" \
             "$configDir/fastfetch" \
             "$configDir/cava/shaders" \
             "$configDir/Kvantum" \
             "$configDir/qt5ct/colors" \
             "$configDir/qt6ct/colors" \
             "$configDir/swappy" \
             "$configDir/networkmanager-dmenu"

    # ── Hyprland core configs ──
    cp -f ${dotfilesSrc}/hypr/hyprland.conf "$configDir/hypr/hyprland.conf"
    cp -f ${dotfilesSrc}/hypr/hyprlock.conf "$configDir/hypr/hyprlock.conf"
    cp -f ${dotfilesSrc}/hypr/hypridle.conf "$configDir/hypr/hypridle.conf"
    cp -f ${dotfilesSrc}/hypr/initial-boot.sh "$configDir/hypr/initial-boot.sh"
    chmod +x "$configDir/hypr/initial-boot.sh"

    # ── Hyprland sub-configs ──
    cp -rf ${dotfilesSrc}/hypr/configs/* "$configDir/hypr/configs/"
    cp -rf ${dotfilesSrc}/hypr/UserConfigs/* "$configDir/hypr/UserConfigs/"
    cp -rf ${dotfilesSrc}/hypr/animations/* "$configDir/hypr/animations/"
    cp -rf ${dotfilesSrc}/hypr/wallust/* "$configDir/hypr/wallust/"
    cp -rf ${dotfilesSrc}/hypr/wallpaper_effects/* "$configDir/hypr/wallpaper_effects/" 2>/dev/null || true
    cp -rf ${dotfilesSrc}/hypr/Monitor_Profiles/* "$configDir/hypr/Monitor_Profiles/" 2>/dev/null || true

    # ── Scripts ──
    for script in ${dotfilesSrc}/hypr/scripts/*; do
      base=$(basename "$script")
      # Skip distro-specific TUI binaries
      case "$base" in dots-tui-ubuntu*) continue;; esac
      cp -f "$script" "$configDir/hypr/scripts/$base"
      chmod +x "$configDir/hypr/scripts/$base"
    done

    for script in ${dotfilesSrc}/hypr/UserScripts/*; do
      base=$(basename "$script")
      cp -f "$script" "$configDir/hypr/UserScripts/$base"
      chmod +x "$configDir/hypr/UserScripts/$base"
    done

    # ── Waybar ──
    # Copy module definition files
    for f in Modules ModulesCustom ModulesGroups ModulesWorkspaces ModulesVertical UserModules; do
      if [ -f "${dotfilesSrc}/waybar/$f" ]; then
        cp -f "${dotfilesSrc}/waybar/$f" "$configDir/waybar/$f"
      fi
    done

    # Copy configs and styles directories
    rm -rf "$configDir/waybar/configs" "$configDir/waybar/style" "$configDir/waybar/wallust"
    cp -r ${dotfilesSrc}/waybar/configs "$configDir/waybar/configs"
    cp -r ${dotfilesSrc}/waybar/style "$configDir/waybar/style"
    cp -r ${dotfilesSrc}/waybar/wallust "$configDir/waybar/wallust"

    # Set default waybar layout/style (preserve user's choice if already set)
    if [ ! -L "$configDir/waybar/config" ] || [ ! -e "$configDir/waybar/config" ]; then
      ln -sf "$configDir/waybar/configs/[TOP] Default" "$configDir/waybar/config"
    fi
    if [ ! -L "$configDir/waybar/style.css" ] || [ ! -e "$configDir/waybar/style.css" ]; then
      ln -sf "$configDir/waybar/style/[Extra] Neon Circuit.css" "$configDir/waybar/style.css"
    fi

    # ── Rofi ──
    rm -rf "$configDir/rofi/themes" "$configDir/rofi/wallust"
    cp -f ${dotfilesSrc}/rofi/config.rasi "$configDir/rofi/config.rasi"
    cp -r ${dotfilesSrc}/rofi/themes "$configDir/rofi/themes"
    cp -r ${dotfilesSrc}/rofi/wallust "$configDir/rofi/wallust"

    # ── SwayNC ──
    cp -f ${dotfilesSrc}/swaync/config.json "$configDir/swaync/config.json"
    cp -f ${dotfilesSrc}/swaync/style.css "$configDir/swaync/style.css"
    cp -rf ${dotfilesSrc}/swaync/icons "$configDir/swaync/" 2>/dev/null || true
    cp -rf ${dotfilesSrc}/swaync/images "$configDir/swaync/" 2>/dev/null || true

    # ── Wlogout ──
    cp -f ${dotfilesSrc}/wlogout/layout "$configDir/wlogout/layout"
    cp -f ${dotfilesSrc}/wlogout/style.css "$configDir/wlogout/style.css"
    cp -rf ${dotfilesSrc}/wlogout/icons/* "$configDir/wlogout/icons/" 2>/dev/null || true

    # ── Wallust ──
    cp -f ${dotfilesSrc}/wallust/wallust.toml "$configDir/wallust/wallust.toml"
    cp -rf ${dotfilesSrc}/wallust/templates/* "$configDir/wallust/templates/"

    # ── Kitty ──
    cp -rf ${dotfilesSrc}/kitty/* "$configDir/kitty/"

    # ── Btop ──
    cp -rf ${dotfilesSrc}/btop/* "$configDir/btop/"

    # ── Fastfetch ──
    cp -rf ${dotfilesSrc}/fastfetch/* "$configDir/fastfetch/"

    # ── Cava ──
    cp -rf ${dotfilesSrc}/cava/* "$configDir/cava/"

    # ── Qt / Kvantum theming ──
    cp -rf ${dotfilesSrc}/Kvantum/* "$configDir/Kvantum/"
    cp -rf ${dotfilesSrc}/qt5ct/* "$configDir/qt5ct/"
    cp -rf ${dotfilesSrc}/qt6ct/* "$configDir/qt6ct/"

    # ── Swappy ──
    cp -rf ${dotfilesSrc}/swappy/* "$configDir/swappy/"

    # ── NetworkManager dmenu ──
    cat > "$configDir/networkmanager-dmenu/config.ini" << 'NMEOF'
[dmenu]
dmenu_command = rofi -dmenu -p Network

[editor]
terminal = ghostty
gui_if_available = False
NMEOF

    # ── Create monitors.conf and workspaces.conf if missing (sourced by hyprland.conf) ──
    [ -f "$configDir/hypr/monitors.conf" ] || echo "# monitor = , preferred, auto, 1, vrr, 2" > "$configDir/hypr/monitors.conf"
    [ -f "$configDir/hypr/workspaces.conf" ] || echo "# Workspace rules" > "$configDir/hypr/workspaces.conf"

    # ── Fix ownership ──
    chown -R jboe:users "$configDir/hypr" "$configDir/waybar" "$configDir/rofi" \
      "$configDir/swaync" "$configDir/wlogout" "$configDir/wallust" "$configDir/kitty" \
      "$configDir/btop" "$configDir/fastfetch" "$configDir/cava" "$configDir/Kvantum" \
      "$configDir/qt5ct" "$configDir/qt6ct" "$configDir/swappy" "$configDir/networkmanager-dmenu"
  '';
}
