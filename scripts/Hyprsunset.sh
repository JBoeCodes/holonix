#!/usr/bin/env bash
set -euo pipefail

# Hyprsunset toggle + Waybar status helper

STATE_FILE="$HOME/.cache/.hyprsunset_state"
TARGET_TEMP="${HYPRSUNSET_TEMP:-4500}"

ensure_state() {
  [[ -f "$STATE_FILE" ]] || echo "off" > "$STATE_FILE"
}

cmd_toggle() {
  ensure_state
  state="$(cat "$STATE_FILE" || echo off)"

  if pgrep -x hyprsunset >/dev/null 2>&1; then
    pkill -x hyprsunset || true
    sleep 0.2
  fi

  if [[ "$state" == "on" ]]; then
    if command -v hyprsunset >/dev/null 2>&1; then
      nohup hyprsunset -i >/dev/null 2>&1 &
      sleep 0.3 && pkill -x hyprsunset || true
    fi
    echo off > "$STATE_FILE"
    notify-send -u low "Hyprsunset: Disabled" || true
  else
    if command -v hyprsunset >/dev/null 2>&1; then
      nohup hyprsunset -t "$TARGET_TEMP" >/dev/null 2>&1 &
    fi
    echo on > "$STATE_FILE"
    notify-send -u low "Hyprsunset: Enabled" "${TARGET_TEMP}K" || true
  fi
}

cmd_status() {
  ensure_state
  if pgrep -x hyprsunset >/dev/null 2>&1; then
    onoff="on"
  else
    onoff="$(cat "$STATE_FILE" || echo off)"
  fi

  if [[ "$onoff" == "on" ]]; then
    printf '{"text":"<span size='"'"'18pt'"'"'>🌇</span>","class":"on","tooltip":"Night light on @ %sK"}\n' "$TARGET_TEMP"
  else
    printf '{"text":"<span size='"'"'16pt'"'"'>☀</span>","class":"off","tooltip":"Night light off"}\n'
  fi
}

cmd_init() {
  ensure_state
  state="$(cat "$STATE_FILE" || echo off)"
  if [[ "$state" == "on" ]]; then
    if command -v hyprsunset >/dev/null 2>&1; then
      nohup hyprsunset -t "$TARGET_TEMP" >/dev/null 2>&1 &
    fi
  fi
}

case "${1:-}" in
  toggle) cmd_toggle ;;
  status) cmd_status ;;
  init)   cmd_init ;;
  *)      echo "usage: $0 [toggle|status|init]" >&2; exit 2 ;;
esac
