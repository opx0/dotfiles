#!/usr/bin/env bash
# Block until the compositor has published WAYLAND_DISPLAY into the systemd user
# manager. Run as voxtype.service's ExecStartPre.
#
# Why this exists:
#   install.sh hooks voxtype.service to default.target, because Hyprland never
#   activates graphical-session.target and the unit was otherwise "enabled" but
#   dead on every boot. That fixed the daemon being absent and replaced it with
#   the daemon being blind: default.target is reached at login, while Hyprland
#   only runs `dbus-update-activation-environment --systemd WAYLAND_DISPLAY ...`
#   afterwards. voxtype came up with no display in its environment.
#
#   Nothing reports this. Transcription is pure compute and succeeds, but BOTH
#   output drivers are Wayland clients -- wtype, and the wl-copy that
#   fallback_to_clipboard falls back to -- so every transcription is typed into
#   nowhere. `voxtype status` still says idle; the journal logs no failure. The
#   only visible symptom is the OSD child exiting with "Failed to open display",
#   which reads as a cosmetic overlay problem and is not.
#
#   systemd builds each Exec* command's environment from the manager's
#   environment block at fork time, so blocking here is enough: ExecStart
#   inherits whatever the compositor published while this script waited.
#   (Verified: an ExecStartPre that sets a var has it visible in ExecStart.)
set -euo pipefail

i=0
while [ "$i" -lt 60 ]; do
  if systemctl --user show-environment | grep -q '^WAYLAND_DISPLAY='; then
    exit 0
  fi
  i=$((i + 1))
  sleep 0.5
done

# 30s with no compositor: a TTY login, or a non-Wayland session. Start anyway
# rather than failing the unit -- `voxtype transcribe` on a file still works
# there, and a hard failure would be a worse regression than a blind daemon.
echo "voxtype: no WAYLAND_DISPLAY after 30s; starting without a display" >&2
exit 0
