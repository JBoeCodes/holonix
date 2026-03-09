{ pkgs, ... }:

let
  modelName = "ggml-base.en.bin";
  modelDir = "/home/jboe/.local/share/whisper";
  modelPath = "${modelDir}/${modelName}";
  pidFile = "/tmp/dictate-recording.pid";
  wavFile = "/tmp/dictate-recording.wav";

  dictate = pkgs.writeShellScriptBin "dictate" ''
    exec >> /tmp/dictate.log 2>&1
    echo "=== dictate invoked at $(date) ==="

    export YDOTOOL_SOCKET="/run/user/$(id -u)/.ydotool_socket"

    NOTIFY="${pkgs.libnotify}/bin/notify-send"
    SOX="${pkgs.sox}/bin/rec"
    WHISPER="${pkgs.whisper-cpp}/bin/whisper-cli"
    WL_COPY="${pkgs.wl-clipboard}/bin/wl-copy"
    YDOTOOL="${pkgs.ydotool}/bin/ydotool"

    PID_FILE="${pidFile}"
    WAV_FILE="${wavFile}"
    MODEL="${modelPath}"

    if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
      echo "Stopping recording..."
      kill "$(cat "$PID_FILE")" 2>/dev/null || true
      rm -f "$PID_FILE"
      sleep 0.3
      $NOTIFY -t 2000 "Dictation" "Transcribing..."

      echo "Running whisper..."
      TEXT=$($WHISPER -m "$MODEL" -f "$WAV_FILE" --no-timestamps -nt 2>/dev/null) || true
      echo "Whisper raw output: '$TEXT'"
      TEXT=$(echo "$TEXT" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr -d '\n')
      echo "Cleaned text: '$TEXT'"

      rm -f "$WAV_FILE"

      if [ -z "$TEXT" ]; then
        echo "No speech detected"
        $NOTIFY -t 3000 "Dictation" "No speech detected"
        exit 0
      fi

      echo "Copying to clipboard and typing text..."
      echo -n "$TEXT" | $WL_COPY
      sleep 0.1
      $YDOTOOL type -- "$TEXT" || echo "ydotool type failed: $?"

      $NOTIFY -t 3000 "Dictation" "$TEXT"
      echo "Done."
    else
      if [ ! -f "$MODEL" ]; then
        $NOTIFY -t 3000 "Dictation" "Model not found. Run nixos-rebuild first."
        exit 1
      fi

      rm -f "$WAV_FILE"
      $SOX -t pulseaudio default "$WAV_FILE" rate 16k channels 1 &
      echo $! > "$PID_FILE"
      echo "Recording started, PID=$(cat "$PID_FILE")"
      $NOTIFY -t 2000 "Dictation" "Recording..."
    fi
  '';
in
{
  users.users.jboe.packages = [ dictate ];

  # ydotool daemon needed for simulating keypresses on GNOME Wayland
  systemd.user.services.ydotoold = {
    description = "ydotoold - ydotool daemon";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.ydotool}/bin/ydotoold";
      Restart = "on-failure";
    };
  };

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
