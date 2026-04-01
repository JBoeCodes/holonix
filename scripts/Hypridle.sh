#!/usr/bin/env bash
# Hypridle toggle for waybar module

case "${1:-}" in
  toggle)
    if pgrep -x hypridle >/dev/null 2>&1; then
      pkill -x hypridle
      notify-send -u low "Hypridle: Disabled" || true
    else
      hypridle &
      notify-send -u low "Hypridle: Enabled" || true
    fi
    ;;
  status)
    if pgrep -x hypridle >/dev/null 2>&1; then
      printf '{"text":"󱫗 ","class":"active","tooltip":"Hypridle active"}\n'
    else
      printf '{"text":"󱫗 ","class":"inactive","tooltip":"Hypridle inactive"}\n'
    fi
    ;;
  *)
    echo "usage: $0 [toggle|status]" >&2
    exit 2
    ;;
esac
