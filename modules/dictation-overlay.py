#!/usr/bin/env python3
"""Dictation overlay — Wispr Flow-style animated waveform bar.

States: idle (hidden) → recording (waveform) → transcribing (pulsing) → idle
Controlled via D-Bus action: com.jboe.Dictation / toggle action

Uses GTK4 Application's built-in D-Bus action support.
Trigger with:
  dbus-send --session --dest=com.jboe.Dictation
    /com/jboe/Dictation org.freedesktop.Application.ActivateAction
    string:toggle array:variant: dict:string:variant:
"""

import json
import math
import os
import socket
import subprocess
import tempfile
import threading
import time
import wave

import gi
gi.require_version("Gtk", "4.0")
gi.require_version("Gdk", "4.0")
from gi.repository import Gdk, Gio, GLib, Gtk

import numpy as np
import sounddevice as sd

WHISP_AWAY_SOCKET = "/tmp/whisp-away-daemon.sock"
SAMPLE_RATE = 16000
CHANNELS = 1
BAR_COUNT = 12
BAR_WIDTH = 6
BAR_GAP = 4
BAR_MAX_HEIGHT = 28
OVERLAY_WIDTH = 280
OVERLAY_HEIGHT = 44
FPS = 30

CSS = """
window.dictation-overlay, window.dictation-overlay headerbar {
    background-color: transparent;
    box-shadow: none;
    border: none;
    padding: 0;
    margin: 0;
    min-height: 0;
}
label.transcribing {
    color: rgba(255, 255, 255, 0.9);
    font-size: 13px;
    font-weight: 500;
}
"""


class DictationOverlay(Gtk.Application):
    def __init__(self):
        super().__init__(
            application_id="com.jboe.Dictation",
            flags=Gio.ApplicationFlags.DEFAULT_FLAGS,
        )
        self.state = "idle"
        self.window = None
        self.drawing_area = None
        self.label = None
        self.stack = None
        self.rms_levels = [0.0] * BAR_COUNT
        self.recording_frames = []
        self.stream = None
        self.tick_id = None
        self.pulse_start = 0.0

        # Register "toggle" action (available via D-Bus)
        action = Gio.SimpleAction.new("toggle", None)
        action.connect("activate", self._on_toggle_action)
        self.add_action(action)

    def _on_toggle_action(self, action, param):
        self._toggle()

    def do_activate(self):
        if self.window is not None:
            return
        self._setup_css()
        self._build_window()
        self.window.set_visible(False)

    def _setup_css(self):
        provider = Gtk.CssProvider()
        provider.load_from_string(CSS)
        Gtk.StyleContext.add_provider_for_display(
            Gdk.Display.get_default(), provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION,
        )

    def _build_window(self):
        self.window = Gtk.Window(application=self)
        self.window.set_default_size(OVERLAY_WIDTH, OVERLAY_HEIGHT)
        self.window.set_resizable(False)
        self.window.set_decorated(False)
        self.window.add_css_class("dictation-overlay")

        self.stack = Gtk.Stack()
        self.stack.set_transition_type(Gtk.StackTransitionType.CROSSFADE)
        self.stack.set_transition_duration(200)

        # Waveform page
        self.drawing_area = Gtk.DrawingArea()
        self.drawing_area.set_content_width(OVERLAY_WIDTH)
        self.drawing_area.set_content_height(OVERLAY_HEIGHT)
        self.drawing_area.set_draw_func(self._draw_waveform)
        self.stack.add_named(self.drawing_area, "waveform")

        # Transcribing page
        self.label = Gtk.Label(label="Transcribing\u2026")
        self.label.add_css_class("transcribing")
        self.stack.add_named(self.label, "transcribing")

        self.window.set_child(self.stack)

    def _toggle(self):
        if self.state == "idle":
            self._start_recording()
        elif self.state == "recording":
            self._stop_recording()

    def _start_recording(self):
        self.state = "recording"
        self.recording_frames = []
        self.rms_levels = [0.0] * BAR_COUNT

        self.stream = sd.InputStream(
            samplerate=SAMPLE_RATE, channels=CHANNELS, dtype="int16",
            blocksize=int(SAMPLE_RATE * 0.05),
            callback=self._audio_callback,
        )
        self.stream.start()

        self.stack.set_visible_child_name("waveform")
        self.window.present()
        self.tick_id = GLib.timeout_add(1000 // FPS, self._tick)

    def _audio_callback(self, indata, frames, time_info, status):
        self.recording_frames.append(indata.copy())
        rms = np.sqrt(np.mean(indata.astype(np.float32) ** 2)) / 32768.0
        self.rms_levels.pop(0)
        self.rms_levels.append(min(rms * 8.0, 1.0))

    def _tick(self):
        if self.state == "recording":
            self.drawing_area.queue_draw()
            return True
        if self.state == "transcribing":
            self.label.set_opacity(
                0.5 + 0.5 * math.sin(time.monotonic() - self.pulse_start)
            )
            return True
        return False

    def _draw_waveform(self, area, cr, width, height):
        # Draw rounded background
        self._rounded_rect(cr, 0, 0, width, height, 22)
        cr.set_source_rgba(0.118, 0.118, 0.118, 0.85)
        cr.fill()

        total_bars_width = BAR_COUNT * BAR_WIDTH + (BAR_COUNT - 1) * BAR_GAP
        x_start = (width - total_bars_width) / 2.0

        # Red recording dot
        cr.set_source_rgba(1.0, 0.3, 0.3, 0.95)
        dot_x = x_start - 14
        dot_y = height / 2.0
        cr.arc(dot_x, dot_y, 4, 0, 2 * math.pi)
        cr.fill()

        # Waveform bars
        cr.set_source_rgba(1.0, 1.0, 1.0, 0.9)
        for i, level in enumerate(self.rms_levels):
            bar_h = max(4, level * BAR_MAX_HEIGHT)
            x = x_start + i * (BAR_WIDTH + BAR_GAP)
            y = (height - bar_h) / 2.0
            self._rounded_rect(cr, x, y, BAR_WIDTH, bar_h, BAR_WIDTH / 2.0)
            cr.fill()

    @staticmethod
    def _rounded_rect(cr, x, y, w, h, r):
        r = min(r, w / 2.0, h / 2.0)
        cr.new_sub_path()
        cr.arc(x + w - r, y + r, r, -math.pi / 2, 0)
        cr.arc(x + w - r, y + h - r, r, 0, math.pi / 2)
        cr.arc(x + r, y + h - r, r, math.pi / 2, math.pi)
        cr.arc(x + r, y + r, r, math.pi, 3 * math.pi / 2)
        cr.close_path()

    def _stop_recording(self):
        self.state = "transcribing"
        self.pulse_start = time.monotonic()
        self.stack.set_visible_child_name("transcribing")

        if self.stream:
            self.stream.stop()
            self.stream.close()
            self.stream = None

        frames = self.recording_frames
        self.recording_frames = []
        threading.Thread(target=self._transcribe, args=(frames,), daemon=True).start()

    def _transcribe(self, frames):
        try:
            if not frames:
                GLib.idle_add(self._finish, "")
                return

            audio_data = np.concatenate(frames, axis=0)
            tmp = tempfile.NamedTemporaryFile(suffix=".wav", delete=False)
            tmp_path = tmp.name
            with wave.open(tmp, "wb") as wf:
                wf.setnchannels(CHANNELS)
                wf.setsampwidth(2)
                wf.setframerate(SAMPLE_RATE)
                wf.writeframes(audio_data.tobytes())

            text = self._query_whisp_away(tmp_path)
            os.unlink(tmp_path)
            GLib.idle_add(self._finish, text.strip())
        except Exception as e:
            print(f"Transcription error: {e}")
            GLib.idle_add(self._finish, "")

    def _query_whisp_away(self, audio_path):
        sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        sock.connect(WHISP_AWAY_SOCKET)
        sock.settimeout(30.0)
        request = json.dumps({"audio_path": audio_path}) + "\n"
        sock.sendall(request.encode())

        data = b""
        while True:
            chunk = sock.recv(4096)
            if not chunk:
                break
            data += chunk
        sock.close()

        resp = json.loads(data.decode())
        if resp.get("success"):
            return resp.get("text", "")
        else:
            print(f"WhispAway error: {resp.get('error', 'unknown')}")
            return ""

    def _finish(self, text):
        if self.tick_id:
            GLib.source_remove(self.tick_id)
            self.tick_id = None

        self.window.set_visible(False)
        self.state = "idle"

        if text:
            self._type_text(text)

    def _type_text(self, text):
        ydotool = os.environ.get("YDOTOOL_PATH", "ydotool")
        wl_copy = os.environ.get("WL_COPY_PATH", "wl-copy")

        subprocess.run([wl_copy, "--", text], check=False)
        subprocess.run(
            [ydotool, "type", "-d", "0", "-H", "0", "--", text],
            env={**os.environ, "YDOTOOL_SOCKET": os.environ.get(
                "YDOTOOL_SOCKET",
                f"/run/user/{os.getuid()}/.ydotool_socket"
            )},
            check=False,
        )


if __name__ == "__main__":
    app = DictationOverlay()
    app.run(None)
