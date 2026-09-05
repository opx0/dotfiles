# voxtype: give the CLI the same GPU pin the daemon gets.
#
# voxtype-gpu-pin.sh writes the detected dGPU index to two places: a systemd
# drop-in for the daemon, and ~/.config/environment.d/ intended for the login
# session. The second one never arrives -- environment.d is read by
# `systemd --user`, and Hyprland is started by the display manager rather than
# as a systemd unit, so an interactive shell inherits nothing from it.
#
# Unpinned, ggml takes Vulkan0, which on this laptop is the Intel iGPU:
# `voxtype transcribe` on the same clip measured 29.31s there against 3.95s on
# the dGPU, with no error either way. The daemon is unaffected (it reads the
# drop-in), so this only shows up when transcribing from a terminal.
#
# The value stays host-specific and gitignored; only this sourcing line is
# tracked, so a fresh install picks up whatever index the pin script detected.
if [ -r "$HOME/.config/environment.d/90-voxtype-gpu.conf" ]; then
  set -a
  source "$HOME/.config/environment.d/90-voxtype-gpu.conf"
  set +a
fi
