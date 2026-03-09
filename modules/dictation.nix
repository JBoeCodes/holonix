{ pkgs, ... }:

let
  modelName = "ggml-base.en.bin";
  modelDir = "/home/jboe/.local/share/whisper";
  modelPath = "${modelDir}/${modelName}";
  pidFile = "/tmp/dictate-recording.pid";
  wavFile = "/tmp/dictate-recording.wav";

  dictate = pkgs.writeShellScriptBin "dictate" ''
    set -euo pipefail

    NOTIFY="${pkgs.libnotify}/bin/notify-send"
    SOX="${pkgs.sox}/bin/rec"
    WHISPER="${pkgs.whisper-cpp}/bin/whisper-cli"
    WL_COPY="${pkgs.wl-clipboard}/bin/wl-copy"
    WTYPE="${pkgs.wtype}/bin/wtype"

    PID_FILE="${pidFile}"
    WAV_FILE="${wavFile}"
    MODEL="${modelPath}"

    if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
      # Stop recording
      kill "$(cat "$PID_FILE")" 2>/dev/null || true
      rm -f "$PID_FILE"
      $NOTIFY -t 2000 "Dictation" "Transcribing..."

      # Transcribe
      TEXT=$($WHISPER -m "$MODEL" -f "$WAV_FILE" --no-timestamps -nt 2>/dev/null | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

      rm -f "$WAV_FILE"

      if [ -z "$TEXT" ]; then
        $NOTIFY -t 3000 "Dictation" "No speech detected"
        exit 0
      fi

      # Copy to clipboard and paste
      echo -n "$TEXT" | $WL_COPY
      sleep 0.1
      $WTYPE -M ctrl v -m ctrl

      $NOTIFY -t 3000 "Dictation" "$TEXT"
    else
      # Start recording
      if [ ! -f "$MODEL" ]; then
        $NOTIFY -t 3000 "Dictation" "Model not found. Run nixos-rebuild first."
        exit 1
      fi

      rm -f "$WAV_FILE"
      $SOX -t pulseaudio default "$WAV_FILE" rate 16k channels 1 &
      echo $! > "$PID_FILE"
      $NOTIFY -t 2000 "Dictation" "Recording..."
    fi
  '';
in
{
  users.users.jboe.packages = [ dictate ];

  system.activationScripts.downloadWhisperModel = ''
    MODEL_DIR="${modelDir}"
    MODEL_PATH="${modelPath}"
    if [ ! -f "$MODEL_PATH" ]; then
      mkdir -p "$MODEL_DIR"
      ${pkgs.curl}/bin/curl -L -o "$MODEL_PATH" \
        "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/${modelName}"
      chown -R jboe:users "$MODEL_DIR"
    fi
  '';
}
