#!/usr/bin/env bash
# Waybar module helper scripts (adapted from JaKooLit for NixOS)

term="ghostty"
files="nautilus"

case "${1:-}" in
    --btop)   $term --title btop -e btop ;;
    --nvtop)  $term --title nvtop -e nvtop ;;
    --nmtui)  $term -e nmtui ;;
    --term)   $term & ;;
    --files)  $files & ;;
    *)
        echo "Usage: $0 [--btop|--nvtop|--nmtui|--term|--files]"
        ;;
esac
