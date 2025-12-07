{ config, pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    imagemagick  # For thumbnail generation
  ];

  # Theme picker script with matugen integration
  home.file.".local/bin/theme-picker" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Wallpaper directory
      WALLPAPER_DIR="$HOME/Pictures/wallpapers"
      CACHE_DIR="$HOME/.cache/wallpaper-thumbnails"
      THUMB_SIZE="200x200"

      # Create directories if they don't exist
      mkdir -p "$WALLPAPER_DIR"
      mkdir -p "$CACHE_DIR"

      # Check if wallpaper directory has any images
      shopt -s nullglob
      wallpaper_files=("$WALLPAPER_DIR"/*.{jpg,jpeg,png,webp,JPG,JPEG,PNG,WEBP})
      if [ ''${#wallpaper_files[@]} -eq 0 ]; then
        notify-send "Theme Picker" "No wallpapers found in $WALLPAPER_DIR" -u normal
        exit 1
      fi

      # Generate thumbnails in background
      for wallpaper in "''${wallpaper_files[@]}"; do
        filename=$(basename "$wallpaper")
        thumbnail="$CACHE_DIR/$filename.thumb.jpg"

        # Generate thumbnail if it doesn't exist
        if [ ! -f "$thumbnail" ]; then
          ${pkgs.imagemagick}/bin/convert "$wallpaper" \
            -resize "$THUMB_SIZE^" \
            -gravity center \
            -extent "$THUMB_SIZE" \
            "$thumbnail" 2>/dev/null &
        fi
      done

      # Wait for thumbnail generation to complete
      wait

      # Build rofi menu with image icons
      # Format: "display_name\0icon\x1f/path/to/thumbnail.jpg\n"
      menu=""
      declare -A wallpaper_map

      for wallpaper in "''${wallpaper_files[@]}"; do
        filename=$(basename "$wallpaper")
        name_only="''${filename%.*}"
        thumbnail="$CACHE_DIR/$filename.thumb.jpg"

        # Use original image if thumbnail doesn't exist
        if [ ! -f "$thumbnail" ]; then
          thumbnail="$wallpaper"
        fi

        # Create rofi entry with icon
        menu="''${menu}''${name_only}\0icon\x1f''${thumbnail}\n"
        wallpaper_map["$name_only"]="$wallpaper"
      done

      # Show rofi with image thumbnails
      selected=$(echo -en "$menu" | ${pkgs.rofi}/bin/rofi \
        -dmenu \
        -i \
        -p "  Theme Picker" \
        -theme-str '
          * {
            bg: rgba(30, 30, 46, 0.95);
            bg-alt: rgba(24, 24, 37, 0.95);
            fg: #cdd6f4;
            fg-alt: #89b4fa;
            border: #89b4fa;
            selected: rgba(137, 180, 250, 0.3);
          }

          window {
            transparency: "real";
            background-color: @bg;
            border: 2px;
            border-color: @border;
            border-radius: 16px;
            width: 550px;
            height: 65%;
            padding: 16px;
          }

          mainbox {
            background-color: transparent;
            children: [ inputbar, listview ];
            spacing: 12px;
          }

          inputbar {
            background-color: @bg-alt;
            text-color: @fg;
            border: 2px;
            border-color: @border;
            border-radius: 12px;
            padding: 10px 16px;
            children: [ prompt, entry ];
          }

          prompt {
            background-color: transparent;
            text-color: @fg-alt;
            font: "Hack Nerd Font Bold 13";
          }

          entry {
            background-color: transparent;
            text-color: @fg;
            placeholder: "Search themes...";
            placeholder-color: #6c7086;
          }

          listview {
            background-color: transparent;
            columns: 1;
            lines: 4;
            spacing: 8px;
            scrollbar: true;
            border: 0;
            fixed-height: true;
          }

          scrollbar {
            width: 6px;
            background-color: @bg-alt;
            handle-color: @fg-alt;
            border-radius: 8px;
          }

          element {
            background-color: transparent;
            text-color: @fg;
            border-radius: 10px;
            padding: 8px;
            orientation: horizontal;
            children: [ element-icon, element-text ];
          }

          element selected {
            background-color: @selected;
            text-color: @fg-alt;
            border: 2px;
            border-color: @fg-alt;
          }

          element-icon {
            size: 120px;
            border-radius: 8px;
            margin: 0 12px 0 0;
          }

          element-text {
            background-color: transparent;
            text-color: inherit;
            vertical-align: 0.5;
            font: "Hack Nerd Font 12";
          }
        ')

      # Exit if nothing selected
      [ -z "$selected" ] && exit 0

      # Get full path of selected wallpaper
      selected_wallpaper="''${wallpaper_map[$selected]}"

      if [ -f "$selected_wallpaper" ]; then
        # Show progress notification
        notify-send "Theme Picker" "Generating color scheme from wallpaper..." -u low

        # Generate color scheme with matugen
        matugen image "$selected_wallpaper" 2>&1 | grep -v "Warning"

        # Set wallpaper using swww
        ${pkgs.swww}/bin/swww img "$selected_wallpaper" \
          --transition-type wipe \
          --transition-angle 30 \
          --transition-duration 2 \
          --transition-fps 60

        # Save current wallpaper to file for persistence
        echo "$selected_wallpaper" > "$HOME/.cache/current_wallpaper"

        # Reload applications to apply new theme
        notify-send "Theme Picker" "Applying theme..." -u low

        # Reload Waybar
        pkill waybar
        waybar &

        # Reload Hyprland config (colors)
        hyprctl reload

        # Reload Kitty colors (all instances)
        for socket in /tmp/kitty-*; do
          if [ -S "$socket" ]; then
            ${pkgs.kitty}/bin/kitty @ --to "unix:$socket" set-colors --all --configured ~/.config/kitty/theme.conf 2>/dev/null || true
          fi
        done

        # Notify completion
        notify-send "Theme Applied" "Theme based on $(basename "$selected_wallpaper")" -u normal
      fi
    '';
  };

  # Script to restore last wallpaper on startup
  home.file.".local/bin/restore-wallpaper" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      WALLPAPER_FILE="$HOME/.cache/current_wallpaper"

      # Wait for swww to be ready
      sleep 2

      if [ -f "$WALLPAPER_FILE" ]; then
        wallpaper=$(cat "$WALLPAPER_FILE")
        if [ -f "$wallpaper" ]; then
          # Regenerate theme from saved wallpaper
          matugen image "$wallpaper" 2>&1 | grep -v "Warning"

          # Apply wallpaper
          ${pkgs.swww}/bin/swww img "$wallpaper" --transition-type fade --transition-duration 1
        fi
      fi
    '';
  };

  # Random wallpaper script
  home.file.".local/bin/random-wallpaper" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      WALLPAPER_DIR="$HOME/Pictures/wallpapers"

      # Get random wallpaper
      wallpaper=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n 1)

      if [ -f "$wallpaper" ]; then
        # Generate color scheme with matugen
        matugen image "$wallpaper" 2>&1 | grep -v "Warning"

        # Apply wallpaper
        ${pkgs.swww}/bin/swww img "$wallpaper" \
          --transition-type random \
          --transition-duration 2 \
          --transition-fps 60

        # Save current wallpaper
        echo "$wallpaper" > "$HOME/.cache/current_wallpaper"

        # Reload applications
        pkill waybar; waybar &
        hyprctl reload
        for socket in /tmp/kitty-*; do
          if [ -S "$socket" ]; then
            ${pkgs.kitty}/bin/kitty @ --to "unix:$socket" set-colors --all --configured ~/.config/kitty/theme.conf 2>/dev/null || true
          fi
        done

        notify-send "Random Theme Applied" "$(basename "$wallpaper")" -u low
      fi
    '';
  };
}
