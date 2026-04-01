#!/usr/bin/env bash
# Volume control via wpctl (PipeWire)

step=5

case "${1:-}" in
    --inc)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ ${step}%+
        ;;
    --dec)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ ${step}%-
        ;;
    --toggle)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
    --mic-inc)
        wpctl set-volume @DEFAULT_AUDIO_SOURCE@ ${step}%+
        ;;
    --mic-dec)
        wpctl set-volume @DEFAULT_AUDIO_SOURCE@ ${step}%-
        ;;
    --toggle-mic)
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        ;;
    *)
        echo "Usage: $0 [--inc|--dec|--toggle|--mic-inc|--mic-dec|--toggle-mic]"
        ;;
esac
