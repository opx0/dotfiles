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
- **`input` group** — `sudo usermod -aG input $USER`, needed for voxtype's F8 grab.
- **log out and back in** — for the zsh login shell, and the `input` group, to take effect.

### voxtype

`install.sh` handles it, but two things bite if you touch it by hand:

- **The GPU pin is generated, never committed.** `scripts/voxtype-gpu-pin.sh` detects
  which Vulkan device is the dGPU and writes `~/.config/environment.d/` +
  a systemd drop-in. ggml always uses `Vulkan0`, which on this laptop is the iGPU —
  whisper runs there at **31.85s vs 2.54s** for the same clip, with every status
  command still reporting healthy. The index differs per machine, so it can't be a
  tracked file. Re-run the script after a GPU change.
- **F8 is dead for ~25s after every restart.** The hotkey binds only once the model
  has loaded; until then `voxtype status` says `stopped` and the key does nothing,
  silently. `voxtype record start` works throughout — so "CLI works, F8 doesn't" is
  almost always this. Wait for `Listening for KEY_F8` in `journalctl --user -u voxtype`.

Full writeup, including why the config is generated rather than hand-written:
`~/Archive/MSB/Machine/tools/voxtype/voxtype.md`.

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
