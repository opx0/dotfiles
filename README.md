# My dotfiles

Arch Linux. zsh + tmux + Neovim, symlinked with GNU stow.

## Setup

```sh
git clone https://github.com/aura-zero/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./bootstrap.sh
```

That's the whole thing. It's safe to re-run — every step checks before it acts.

If stow reports conflicts with config files already on the machine:

```sh
./bootstrap.sh --adopt   # pulls those files INTO the repo — check `git diff` after
```

<details>
<summary>What bootstrap.sh does</summary>

| Step | Detail |
|---|---|
| Base tools | `git`, `stow`, `base-devel` |
| AUR helper | builds `yay-bin` if `yay` is missing |
| Packages | everything in `scripts/{pkgs,devTools,sysPkgs}.txt` — repo packages via pacman, the rest via yay |
| Symlinks | `stow` into `$HOME` |
| tmux | clones TPM, installs plugins headlessly (no `prefix + I` needed) |
| zsh | clones zinit, bursts the turbo-loaded plugins |
| Neovim | `lazy.nvim` self-bootstraps, then a headless `Lazy! sync` |
| Login shell | `chsh` to zsh |

Flags: `--adopt`, `--skip-packages`, `--help`.

</details>

Left to you afterwards, because they need your credentials or a private backup:

- **atuin sync** — `atuin register` / `atuin login`. History works locally without it.
- **paid fonts** — restore into `/usr/local/share/fonts/personal/`.
- **reboot, then re-run `./install.sh`** — on a fresh machine with an NVIDIA card. The
  driver is installed but nouveau owns the GPU until reboot, so the first run can't pin
  voxtype to it (it says so, and skips). The second run is seconds.
- **log out and back in** — for the zsh login shell, and the `input` group, to take effect.

### voxtype

`install.sh` handles it. These are the ones that bite, and every one of them fails
silently -- `voxtype status` says `idle` through all of them:

- **The daemon starts blind unless it waits for the compositor.** systemd reaches
  `default.target` at login; Hyprland publishes `WAYLAND_DISPLAY` into the user manager
  only afterwards. Started before that, voxtype has no display -- and both output
  drivers are Wayland clients (`wtype`, and the `wl-copy` that `fallback_to_clipboard`
  falls back to), so **every transcription is typed into nowhere** while nothing logs a
  failure. `scripts/voxtype-wait-wayland.sh` blocks in `ExecStartPre` until the display
  exists. The only visible symptom was the OSD exiting with "Failed to open display",
  which reads as a cosmetic overlay problem and is not.

- **The CLI needs the pin too, and gets it from zsh.** The daemon reads the dGPU index
  from its systemd drop-in, but `~/.config/environment.d/` never reaches an interactive
  shell -- it is read by `systemd --user`, and Hyprland isn't a systemd unit here. So
  `voxtype transcribe` ran on the iGPU: **29.31s vs 3.95s** on the same clip.
  `.config/zsh/voxtype.zsh` sources the generated file.

- **The OSD is a replacement, not a theme.** The default gtk4 frontend hardcodes its
  blue waveform; its only knobs are size, margin and gain. The quickshell frontend is
  the styleable one and is **broken in voxtype-bin 1.0.0-2**: `StyleLoader.qml` and
  `RecipeRenderer.qml` are declared in the package's `qmldir` and not shipped, so
  `style`, `palette`, `plugin_path` and `[[osd.visual.layers]]` are all inert.
  `.config/voxtype/osd-dotmatrix/` is a complete replacement `shell.qml` needing
  neither, pointed at by `VOXTYPE_OSD_QML_PATH` in a generated drop-in. Its board
  colour tracks `~/.local/state/caelestia/scheme.json`, and its -30 dBFS floor is
  measured from this laptop's mic -- re-measure on other hardware, recipe in the file.

- **The GPU pin is generated, never committed.** `scripts/voxtype-gpu-pin.sh` detects
  which Vulkan device is the dGPU and writes `~/.config/environment.d/` +
  a systemd drop-in. ggml always uses `Vulkan0`, which on this laptop is the iGPU —
  whisper runs there at **31.85s vs 2.54s** for the same clip, with every status
  command still reporting healthy. The index differs per machine, so it can't be a
  tracked file. Re-run the script after a GPU change.
- **large-v3 does not fit a 4 GB card on voxtype ≥ 1.0.0.** It loads fine (3.1 GB) and
  the daemon reports healthy, then every transcription fails with
  `ErrorOutOfDeviceMemory`: 1.0.0 allocates two whisper states per utterance. The
  committed config uses `large-v3-turbo`, which also won the accuracy benchmark.
- **F8 is dead for ~8s after every restart.** The hotkey binds only once the model
  has loaded; until then `voxtype status` says `stopped` and the key does nothing,
  silently. `voxtype record start` works throughout — so "CLI works, F8 doesn't" is
  almost always this. Wait for `Listening for KEY_F8` in `journalctl --user -u voxtype`.

Full writeup, including why the config is generated rather than hand-written:
`~/Resources/MSB/machine/tools/voxtype/voxtype.md`.

## What's in here

| Path | |
|---|---|
| [`.config/nvim`](.config/nvim/README.md) | Neovim — plugins, LSP, [keybindings](.config/nvim/KEYBINDINGS.md) |
| [`.config/tmux`](.config/tmux/README.md) | tmux — keybindings, themes, per-host overrides |
| [`.config/zsh`](.config/zsh) | zsh modules, sourced by `.zshrc` |
| [`scripts`](scripts/README.md) | the package lists bootstrap reads |
| `.config/voxtype` | push-to-talk speech-to-text — hold F8, speak, release |
| `.config/starship` | prompt |
| `.config/{ghostty,kitty,wezterm}` | terminal emulators |

Those READMEs are reference — how things are configured and which keys do what. Setup lives here and only here.

## Housekeeping

Symlinks created by stow shouldn't be committed:

```zsh
find . -type l -exec git rm --cached {} \;
```
