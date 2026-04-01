#!/usr/bin/env bash
# Refresh waybar and swaync (adapted from JaKooLit)

# Kill running instances
for proc in waybar rofi swaync; do
  pidof "$proc" >/dev/null && pkill "$proc"
done

sleep 0.1

# Restart waybar
waybar &

# Restart swaync
sleep 0.3
swaync >/dev/null 2>&1 &
swaync-client --reload-config

exit 0
