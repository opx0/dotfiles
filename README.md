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
- **log out and back in** — for the zsh login shell to take effect.

## What's in here

| Path | |
|---|---|
| [`.config/nvim`](.config/nvim/README.md) | Neovim — plugins, LSP, [keybindings](.config/nvim/KEYBINDINGS.md) |
| [`.config/tmux`](.config/tmux/README.md) | tmux — keybindings, themes, per-host overrides |
| [`.config/zsh`](.config/zsh) | zsh modules, sourced by `.zshrc` |
| [`scripts`](scripts/README.md) | the package lists bootstrap reads |
| `.config/starship` | prompt |
| `.config/{ghostty,kitty,wezterm}` | terminal emulators |

Those READMEs are reference — how things are configured and which keys do what. Setup lives here and only here.

## Housekeeping

Symlinks created by stow shouldn't be committed:

```zsh
find . -type l -exec git rm --cached {} \;
```
