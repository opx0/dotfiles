// Voxtype OSD — monochrome dot-matrix LED panel.
//
// A self-contained Quickshell config, pointed at by VOXTYPE_OSD_QML_PATH
// (see the 30-osd.conf drop-in that install.sh generates).
//
// Why self-contained rather than a [osd] style package:
//   voxtype-bin 1.0.0-2 ships a broken quickshell frontend. Its
//   voxtype-shared/qmldir declares StyleLoader and RecipeRenderer, and both
//   shell.qml and OsdSurface.qml instantiate them, but neither .qml file is in
//   the package:
//     ERROR: Type VT.StyleLoader unavailable — File not found
//   StyleLoader is what resolves [osd] plugin_path, style, palette and the
//   [[osd.visual.layers]] recipe list, so every one of those config knobs is
//   dead on this install. Replacing shell.qml wholesale via --qml-path is the
//   only route that works, and it needs neither missing file.
//
// Only AudioBridge (the NDJSON sidecar wrapper, protocol documented as locked)
// and StateReader (a FileView on the daemon state file) are imported from the
// package by absolute path. Both ship and both work; a qmldir naming a missing
// file is harmless as long as that type is never instantiated.

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "voxtype-shared" as VT

ShellRoot {
    id: shell

    VT.StateReader { id: stateReader }
    VT.AudioBridge { id: audio }

    PanelWindow {
        id: panel

        readonly property string daemonState: stateReader.state

        // ---- grid geometry -------------------------------------------------
        // Pitch is the cell size; the dot is drawn concentric inside it, so the
        // unlit gap is what sells the LED-panel look. Odd row count gives a true
        // centre row for the waveform baseline.
        readonly property int pitch: 5
        readonly property int cols: 48
        readonly property int rows: 9
        readonly property real dotRadius: 1.5
        readonly property int panelW: cols * pitch
        readonly property int panelH: rows * pitch
        readonly property int padding: 8
        readonly property int marginPx: 24

        // ---- signal history ------------------------------------------------
        // Fixed 300-sample ring = 3 s at the daemon's 100 Hz frame rate, matching
        // the built-in surface's window. Held at full length and pre-zeroed so
        // the column mapping below is a plain bucket-max with no edge cases.
        readonly property int ringLen: 300
        property var ring: new Array(300).fill(0)

        // Level mapping is dB, not linear. The built-in frontends' linear
        // waveformGain of 10.0 clips any peak above 0.1 to full height, and on a
        // 9-row matrix that reads as a solid block with no dynamics at all.
        //
        // The floor is the panel's zero point, and -60 (what the built-in peak
        // meter uses) is wrong for this mic: measured over 294 frames of a silent
        // room, its noise floor is -23.3 dBFS median / -18.4 peak, which -60 maps
        // to 61% height -- a fat bar that never moves. -30 puts silence at roughly
        // one row and leaves the rest of the panel for speech.
        //
        // Re-measure on a different mic: `voxtype record start`, then
        // `voxtype-audio-bridge` for a few seconds, and read the peak percentiles.
        readonly property real floorDbfs: -30.0

        property int phase: 0

        // ---- board colour --------------------------------------------------
        // Tracked from the live system scheme rather than hardcoded, so the panel
        // stays matched when the theme changes instead of drifting into a black
        // rectangle on a themed desktop. caelestia writes the active palette
        // here; surfaceContainerLowest is its darkest surface -- #0e0e12 on the
        // current catppuccin/mocha, and genuinely darker than this scheme's
        // remapped crust (#121216), which is what "darkest" would otherwise mean.
        // The literal below is the fallback when the file is absent.
        property color boardColor: "#0e0e12"
        readonly property real boardAlpha: 0.26

        function applyScheme(raw) {
            try {
                const c = JSON.parse(raw).colours;
                // Values are bare hex with no leading '#'.
                if (c && c.surfaceContainerLowest) {
                    boardColor = "#" + c.surfaceContainerLowest;
                }
            } catch (e) {
                // Half-written or malformed file: keep the colour we have.
            }
        }

        FileView {
            path: (Quickshell.env("HOME") || "") + "/.local/state/caelestia/scheme.json"
            watchChanges: true
            printErrors: false
            onFileChanged: reload()
            onLoaded: panel.applyScheme(text())
        }

        visible: daemonState !== "idle" && daemonState !== ""

        anchors { top: true; bottom: true; left: true; right: true }
        color: "transparent"

        WlrLayershell.namespace: "voxtype-osd"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        exclusionMode: ExclusionMode.Ignore

        // Pass pointer events through: the surface is fullscreen-anchored and
        // transparent, so without this it would swallow every click.
        mask: Region {
            intersection: Intersection.Subtract
            x: 0; y: 0
            width: panel.width
            height: panel.height
        }

        function resetRing() {
            ring = new Array(ringLen).fill(0);
            phase = 0;
            matrix.requestPaint();
        }

        onDaemonStateChanged: {
            if (daemonState === "idle" || daemonState === "") resetRing();
        }

        Connections {
            target: audio
            function onFrameReceived(peak, rms, vad, tsMs) {
                const r = panel.ring;
                r.shift();
                r.push(peak);
                panel.ring = r;
            }
            function onDisconnected() { panel.resetRing(); }
        }

        // Repaint clock. Only ticks while the panel is up, so an idle daemon
        // costs nothing.
        Timer {
            interval: 16
            repeat: true
            running: panel.visible
            onTriggered: {
                panel.phase = (panel.phase + 1) % 100000;
                matrix.requestPaint();
            }
        }

        Rectangle {
            id: board
            width: panel.panelW + panel.padding * 2
            height: panel.panelH + panel.padding * 2
            x: Math.max(panel.marginPx, (panel.width - width) / 2)
            y: Math.max(panel.marginPx, panel.height - height - panel.marginPx)
            radius: 5
            color: Qt.rgba(panel.boardColor.r, panel.boardColor.g,
                           panel.boardColor.b, panel.boardAlpha)

            Canvas {
                id: matrix
                anchors.centerIn: parent
                width: panel.panelW
                height: panel.panelH
                antialiasing: true

                // Column value from the ring: bucket-max over the samples this
                // column covers, so a short transient still lights a dot instead
                // of being averaged away.
                function columnValue(c) {
                    const lo = Math.floor(c * panel.ringLen / panel.cols);
                    const hi = Math.floor((c + 1) * panel.ringLen / panel.cols);
                    let m = 0;
                    for (let i = lo; i < hi; i++) {
                        const v = panel.ring[i];
                        if (v > m) m = v;
                    }
                    if (m <= 0) return 0;
                    const db = 20 * Math.log10(m);
                    if (db <= panel.floorDbfs) return 0;
                    return Math.min(1.0, (db - panel.floorDbfs) / -panel.floorDbfs);
                }

                function litRowsFor(c) {
                    const half = (panel.rows - 1) / 2;
                    return Math.round(columnValue(c) * half);
                }

                onPaint: {
                    const ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);

                    const half = (panel.rows - 1) / 2;
                    const recording = panel.daemonState === "recording"
                                   || panel.daemonState === "streaming";
                    // No frames arrive while the model runs, so the waveform would
                    // freeze mid-transcription. Sweep a lit column instead to show
                    // it is still working.
                    const sweeping = panel.daemonState === "transcribing";
                    const sweepCol = sweeping
                        ? Math.floor((panel.phase / 2) % panel.cols)
                        : -1;
                    // Voice gate is the daemon's own VAD: dim the panel when it is
                    // recording but hearing nothing, which is the same cue the
                    // built-in surface gives by dropping card opacity.
                    const gated = recording && audio.running && !audio.vad;

                    for (let c = 0; c < panel.cols; c++) {
                        const lit = recording ? litRowsFor(c) : 0;
                        for (let r = 0; r < panel.rows; r++) {
                            const dist = Math.abs(r - half);
                            let on = false;
                            let alpha = 0.10;

                            if (recording) {
                                // Centre row is always lit: it reads as the
                                // baseline the envelope grows out of.
                                on = dist === 0 || dist <= lit;
                            } else if (sweeping) {
                                const d = Math.abs(c - sweepCol);
                                on = d <= 1 || dist === 0;
                                if (d <= 1 && dist !== 0) alpha = 0.85;
                            }

                            if (on) alpha = gated ? 0.50 : 0.95;
                            if (sweeping && !on) alpha = 0.10;

                            ctx.beginPath();
                            ctx.fillStyle = Qt.rgba(1, 1, 1, alpha);
                            ctx.arc(c * panel.pitch + panel.pitch / 2,
                                    r * panel.pitch + panel.pitch / 2,
                                    panel.dotRadius, 0, Math.PI * 2);
                            ctx.fill();
                        }
                    }
                }
            }
        }
    }
}
