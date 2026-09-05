#!/usr/bin/env bash
# One-shot setup for these dotfiles on Arch Linux.
#
#   ./bootstrap.sh              full setup
#   ./bootstrap.sh --adopt      let stow adopt pre-existing config files
#   ./bootstrap.sh --skip-packages
#
# Safe to re-run: every step checks before it acts.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# TPM lives beside the tmux config (XDG layout) — .config/tmux/.gitignore ignores it.
TPM_DIR="$HOME/.config/tmux/plugins/tpm"
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
PACKAGE_LISTS=(pkgs.txt devTools.txt sysPkgs.txt)

STOW_ADOPT=0
SKIP_PACKAGES=0
NEEDS_REBOOT=0

for arg in "$@"; do
  case "$arg" in
    --adopt)         STOW_ADOPT=1 ;;
    --skip-packages) SKIP_PACKAGES=1 ;;
    -h|--help)       sed -n '2,9p' "${BASH_SOURCE[0]}" | sed 's/^# \?//'; exit 0 ;;
    *) echo "unknown flag: $arg (try --help)" >&2; exit 1 ;;
  esac
done

step() { printf '\n\033[1;34m==>\033[0m \033[1m%s\033[0m\n' "$1"; }
ok()   { printf '  \033[32m✓\033[0m %s\n' "$1"; }
warn() { printf '  \033[33m!\033[0m %s\n' "$1"; }
die()  { printf '\n\033[31mERROR:\033[0m %s\n' "$1" >&2; exit 1; }

# ---------------------------------------------------------------- preflight --
step "Preflight"
command -v pacman >/dev/null || die "this bootstrap targets Arch Linux (no pacman found)"
[ "$(id -u)" -ne 0 ] || die "run as your normal user, not root (sudo is called where needed)"
ok "Arch Linux detected"

echo "  Some steps need sudo — you may be prompted now."
sudo -v

# --------------------------------------------------------------- base tools --
step "Base tools (git, stow, base-devel)"
sudo pacman -S --needed --noconfirm git stow base-devel
ok "base tools present"

# ---------------------------------------------------------------------- yay --
step "AUR helper (yay)"
if command -v yay >/dev/null; then
  ok "yay already installed"
else
  build_dir="$(mktemp -d)"
  git clone --depth 1 https://aur.archlinux.org/yay-bin.git "$build_dir/yay-bin"
  (cd "$build_dir/yay-bin" && makepkg -si --noconfirm)
  rm -rf "$build_dir"
  ok "yay installed"
fi

# ----------------------------------------------------------------- packages --
step "Packages"
if [ "$SKIP_PACKAGES" -eq 1 ]; then
  warn "skipped (--skip-packages)"
else
  wanted=()
  for list in "${PACKAGE_LISTS[@]}"; do
    file="$DOTFILES/scripts/$list"
    [ -f "$file" ] || die "package list missing: $file"
    while IFS= read -r pkg || [ -n "$pkg" ]; do
      pkg="${pkg%%[[:space:]]*}"
      [[ -z "$pkg" || "$pkg" == \#* || "$pkg" == --\>* ]] && continue
      wanted+=("$pkg")
    done < "$file"
  done

  missing=()
  for pkg in "${wanted[@]}"; do
    pacman -Qi "$pkg" &>/dev/null || missing+=("$pkg")
  done

  if [ "${#missing[@]}" -eq 0 ]; then
    ok "all ${#wanted[@]} packages already installed"
  else
    # Split by origin: exact match in the official repos, else treat as AUR.
    official=() aur=()
    for pkg in "${missing[@]}"; do
      if pacman -Si "$pkg" &>/dev/null; then official+=("$pkg"); else aur+=("$pkg"); fi
    done
    if [ "${#official[@]}" -gt 0 ]; then sudo pacman -S --needed --noconfirm "${official[@]}"; fi
    if [ "${#aur[@]}" -gt 0 ];      then yay -S --needed --noconfirm "${aur[@]}"; fi
    ok "installed ${#missing[@]} of ${#wanted[@]} packages"
  fi
fi

# -------------------------------------------------------------------- stow --
step "Symlinks (stow)"
cd "$DOTFILES"
stow_args=(--target="$HOME")
if [ "$STOW_ADOPT" -eq 1 ]; then stow_args+=(--adopt); fi
if stow "${stow_args[@]}" . ; then
  ok "config symlinked into \$HOME"
else
  die "stow hit conflicting files. Either move them aside, or re-run:
       ./bootstrap.sh --adopt
     (--adopt pulls the existing files INTO this repo — check 'git diff' afterwards)"
fi

# --------------------------------------------------------------------- tmux --
step "tmux plugins"
if command -v tmux >/dev/null; then
  # Check for the binary, not the directory — an empty stub dir can exist.
  if [ ! -x "$TPM_DIR/bin/install_plugins" ]; then
    mkdir -p "$(dirname "$TPM_DIR")"
    rmdir "$TPM_DIR" 2>/dev/null || true   # git clone needs the target empty or absent
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
    ok "cloned TPM"
  else
    ok "TPM present"
  fi

  tmux_ver="$(tmux -V | sed 's/tmux //; s/[a-z]//g')"
  awk -v v="$tmux_ver" 'BEGIN { exit !(v+0 >= 3.2) }' \
    && ok "tmux $tmux_ver (catppuccin v2 needs >= 3.2)" \
    || warn "tmux $tmux_ver is below 3.2 — the catppuccin theme will misbehave"

  # TPM treats any existing directory as an installed plugin, so empty stubs
  # (left by a half-finished checkout) would be silently skipped forever.
  find "$(dirname "$TPM_DIR")" -mindepth 1 -maxdepth 1 -type d -empty -delete 2>/dev/null || true

  # TPM reads @plugin from a live server, so install against a throwaway session.
  tmux new-session -d -s bootstrap-tpm 2>/dev/null || true
  "$TPM_DIR/bin/install_plugins" >/dev/null && ok "tmux plugins installed" \
    || warn "TPM install failed — run 'prefix + I' inside tmux"
  tmux kill-session -t bootstrap-tpm 2>/dev/null || true
else
  warn "tmux not installed — skipping plugins"
fi

# --------------------------------------------------------------------- zsh --
step "zsh (zinit)"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
  ok "cloned zinit"
else
  ok "zinit present"
fi
# Turbo-mode plugins normally load after the first prompt; burst them now.
zsh -ic '@zinit-scheduler burst; exit' >/dev/null 2>&1 \
  && ok "zsh plugins installed" \
  || warn "zsh plugins will install on your first interactive shell"

# -------------------------------------------------------------------- nvim --
step "Neovim plugins"
if command -v nvim >/dev/null; then
  # install + restore, not sync: reproduces the versions pinned in lazy-lock.json
  # instead of updating everything and rewriting the lockfile.
  nvim --headless "+Lazy! install" "+Lazy! restore" +qa >/dev/null 2>&1 \
    && ok "lazy.nvim plugins installed at locked versions" \
    || warn "lazy install failed — plugins will install on first 'nvim' launch"
else
  warn "nvim not installed — skipping"
fi

# ----------------------------------------------------------------- voxtype --
step "voxtype (push-to-talk STT)"
if ! command -v voxtype >/dev/null; then
  warn "voxtype not installed — skipping (it's in scripts/sysPkgs.txt)"
else
  # GPU backend: repoints /usr/bin/voxtype at the Vulkan build.
  if readlink -f /usr/bin/voxtype | grep -q vulkan; then
    ok "vulkan backend already active"
  else
    sudo voxtype setup gpu --enable >/dev/null && ok "vulkan backend enabled"
  fi

  # Fetch models BEFORE enabling the service: a partial .bin still declares full
  # size in its header, so the daemon starts, fails to load it, and crash-loops.
  model="$(sed -n 's/^model *= *"\(.*\)"/\1/p' "$HOME/.config/voxtype/config.toml" 2>/dev/null | head -1)"
  model="${model:-large-v3}"
  models="$HOME/.local/share/voxtype/models"
  [ -f "$models/ggml-silero-vad.bin" ] && ok "VAD model present" \
    || { echo "  downloading Silero VAD…"; voxtype setup vad >/dev/null && ok "VAD model fetched"; }
  [ -f "$models/ggml-${model}.bin" ] && ok "model ${model} present" \
    || { echo "  downloading ${model} (GBs — be patient)…"
         voxtype setup --download --model "$model" >/dev/null && ok "model ${model} fetched"; }

  # After stow (reads the symlinked config) and after the model exists.
  "$DOTFILES/scripts/voxtype-gpu-pin.sh" || warn "GPU pin failed — see scripts/voxtype-gpu-pin.sh"

  voxtype setup systemd >/dev/null 2>&1 || true
  # The daemon starts at login (add-wants below), but Hyprland only publishes
  # WAYLAND_DISPLAY into the user manager afterwards -- so voxtype came up blind.
  # Transcription still succeeded; both output drivers (wtype, and the wl-copy
  # that fallback_to_clipboard uses) are Wayland clients, so every result was
  # typed into nowhere while `voxtype status` reported idle and nothing logged a
  # failure. Block on the display instead: systemd builds ExecStart's environment
  # at fork time, so waiting in ExecStartPre is enough.
  mkdir -p "$HOME/.config/systemd/user/voxtype.service.d"
  cat > "$HOME/.config/systemd/user/voxtype.service.d/20-wayland.conf" <<EOF
# Generated by dotfiles/install.sh -- do not commit, the path is host-specific.
# See dotfiles/scripts/voxtype-wait-wayland.sh for the full why.
[Service]
ExecStartPre=$DOTFILES/scripts/voxtype-wait-wayland.sh
EOF
  # OSD frontend is quickshell (see [osd] in config.toml) because gtk4 hardcodes
  # its blue waveform. The QML path has to come from this env var rather than
  # [osd] plugin_path: plugin_path is read by StyleLoader.qml, which voxtype-bin
  # 1.0.0-2 declares in its qmldir but does not ship, so every style option in
  # the shipped config is inert.
  if command -v qs >/dev/null; then
    cat > "$HOME/.config/systemd/user/voxtype.service.d/30-osd.conf" <<EOF
# Generated by dotfiles/install.sh -- do not commit, the path is host-specific.
[Service]
Environment=VOXTYPE_OSD_QML_PATH=$DOTFILES/.config/voxtype/osd-dotmatrix
EOF
    ok "dot-matrix OSD wired up"
  else
    warn "quickshell missing — no OSD (it's in scripts/sysPkgs.txt); daemon still works"
  fi
  systemctl --user daemon-reload
  # The generated unit wants graphical-session.target, which Hyprland never
  # activates -- "enabled" but dead on every boot. Hook it to default.target too.
  systemctl --user add-wants default.target voxtype.service >/dev/null 2>&1 || true
  systemctl --user enable --now voxtype >/dev/null 2>&1 \
    && ok "voxtype.service enabled (default.target)" || warn "could not enable voxtype.service"

  # evdev grab needs the input group; membership only applies at next login.
  if id -nG | grep -qw input; then
    ok "in the 'input' group"
  else
    sudo usermod -aG input "$USER" && warn "added to 'input' group — F8 works after re-login" \
      || warn "could not add to 'input' group — F8 will never fire"
  fi

  # nvidia-utils installed this run means nouveau still owns the card: the GPU
  # pin above had nothing to pin. Flag it for the summary.
  if lspci -k 2>/dev/null | grep -A2 -iE 'VGA|3D' | grep -q 'driver in use: nouveau'; then
    NEEDS_REBOOT=1
    warn "NVIDIA card is on nouveau — reboot, then re-run ./install.sh to pin the dGPU"
  fi
fi

# ------------------------------------------------------------- login shell --
step "Login shell"
zsh_bin="$(command -v zsh || true)"
if [ -z "$zsh_bin" ]; then
  warn "zsh not installed — skipping chsh"
elif [ "${SHELL:-}" = "$zsh_bin" ]; then
  ok "login shell is already zsh"
else
  echo "  Setting zsh as your login shell (password prompt follows)."
  chsh -s "$zsh_bin" && ok "login shell set to zsh — takes effect next login" \
    || warn "chsh failed — run: chsh -s $zsh_bin"
fi

# -------------------------------------------------------------------- done --
cat <<EOF

$(printf '\033[1;32mBootstrap complete.\033[0m')

Optional, and yours to do:
  • atuin sync    — 'atuin register' or 'atuin login' (history sync is off by default)
  • paid fonts    — restore from your private backup into /usr/local/share/fonts/personal/
  • log out / in  — for the zsh login shell and the 'input' group to take effect

EOF
if [ "$NEEDS_REBOOT" -eq 1 ]; then
  printf '\033[1;33mREBOOT REQUIRED\033[0m — the NVIDIA driver was installed but nouveau still\n'
  printf 'owns the card. After rebooting, run ./install.sh once more: it pins voxtype to\n'
  printf 'the dGPU and restarts it. Until then transcription runs on the iGPU (12x slower).\n\n'
fi
