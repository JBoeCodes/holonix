const APP_ID = 'com.jboe.Dictation';
const BOTTOM_MARGIN = 32;

export default class DictationPositioner {
    _windowCreatedId = null;

    enable() {
        this._windowCreatedId = global.display.connect(
            'window-created',
            (_display, win) => this._onWindowCreated(win),
        );

        // Handle already-open windows
        for (const actor of global.get_window_actors()) {
            this._onWindowCreated(actor.get_meta_window());
        }
    }

    disable() {
        if (this._windowCreatedId) {
            global.display.disconnect(this._windowCreatedId);
            this._windowCreatedId = null;
        }
    }

    _isDictationWindow(win) {
        if (!win)
            return false;

        const gtkId = win.get_gtk_application_id?.() || '';
        if (gtkId === APP_ID)
            return true;

        const sandboxId = win.get_sandboxed_app_id?.() || '';
        if (sandboxId === APP_ID)
            return true;

        const wmClass = (win.get_wm_class() || '').toLowerCase();
        const wmInstance = (win.get_wm_class_instance() || '').toLowerCase();
        if (wmClass.includes('dictation') || wmInstance.includes('dictation'))
            return true;

        return false;
    }

    _onWindowCreated(win) {
        if (!this._isDictationWindow(win))
            return;

        // Wait for the window to have a frame before positioning
        const id = win.connect('position-changed', () => {
            win.disconnect(id);
            this._position(win);
        });

        // Also try immediately in case already mapped
        if (win.get_frame_rect().width > 0)
            this._position(win);
    }

    _position(win) {
        const monitor = win.get_monitor();
        const area = global.display.get_monitor_geometry(monitor);
        const frame = win.get_frame_rect();

        const x = area.x + Math.round((area.width - frame.width) / 2);
        const y = area.y + area.height - frame.height - BOTTOM_MARGIN;

        win.move_frame(false, x, y);
        win.make_above();
    }
}
