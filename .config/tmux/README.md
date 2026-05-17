# tmux config

Unified tmux config for both local dev machines and remote servers, with a swappable theme layer.

## Layout

```
tmux/
├── tmux.conf              # main config (options, plugins)
├── tmux.reset.conf        # custom keybinds, sourced from tmux.conf
└── themes/
    ├── catppuccin.conf    # catppuccin theme + status modules
    └── tokyo-night.conf   # tokyo-night theme + status modules
```

## Install

One-shot:
```bash
./install.sh
```

This symlinks the directory to `~/.config/tmux/`, clones TPM, checks your tmux version, and warns about missing optional deps.

Then in tmux: `prefix + I` to install plugins (prefix is `Ctrl+A`), `prefix + R` to reload.

<details>
<summary>Manual install</summary>

```bash
ln -s "$PWD" ~/.config/tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux         # then: prefix + I, then: prefix + R
```
</details>

## Dependencies

| Tool | Required by | Install |
|---|---|---|
| tmux ≥ 3.2 | catppuccin v2 theme | distro package or build |
| `fzf` | sessionx, fzf-url | `pacman -S fzf` / `apt install fzf` |
| `zoxide` | sessionx (zoxide-mode) | `pacman -S zoxide` / `apt install zoxide` |
| Ruby + thumbs binary | tmux-thumbs hint mode | built by the plugin on first run |

If a dependency is missing on a host, the related keybind just errors silently — tmux itself keeps working. Disable the plugin in `~/.tmux.local.conf` if it's noisy.

## Switching themes

Edit `tmux.conf` and swap which line is commented:

```tmux
source-file ~/.config/tmux/themes/catppuccin.conf       # ← DEV (default)
# source-file ~/.config/tmux/themes/tokyo-night.conf    # ← VPS / alt
```

Then in tmux:
- `prefix + I` — install the newly enabled theme plugin
- `prefix + R` — reload config

To clean up the no-longer-used theme plugin: `prefix + alt + u`.

> **Note:** for the cleanest switch (no stale options lingering in the tmux
> server's memory from the previous theme), `tmux kill-server` and start fresh.
> Reloading alone works most of the time but can leave stale status-line refs.

## Per-host overrides

Create `~/.tmux.local.conf` on any host to override settings — sourced last. Example for a tiny VPS:

```tmux
set -g history-limit 20000
set -g @continuum-restore 'off'
```

## Key bindings

Prefix: `Ctrl+A`

| Key | Action |
|---|---|
| `prefix + s` / `v` | Split vertical / horizontal (preserves cwd) |
| `prefix + c` | New window (preserves cwd) |
| `prefix + Ctrl+c` | New window in `$HOME` |
| `prefix + h/j/k/l` | Select pane |
| `Ctrl + h/j/k/l` | Vim-aware pane nav (seamless with vim splits, no prefix) |
| `Alt + ←/→/↑/↓` | Select pane (no prefix) |
| `Shift + ←/→` | Prev / next window (no prefix) |
| `Alt + H/L` | Prev / next window (no prefix) |
| `prefix + H/L` | Prev / next window |
| `prefix + o` | sessionx (fuzzy session/project switcher) |
| `prefix + p` | floax (floating shell pane) |
| `prefix + z` | Zoom pane |
| `prefix + X` | Kill pane |
| `prefix + x` | Swap pane |
| `prefix + K` | Clear screen |
| `prefix + R` | Reload config |
| `prefix + *` | Toggle synchronize-panes |
| `prefix + Ctrl+a` | Last window |
