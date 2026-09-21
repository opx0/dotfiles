# tmux config

This started as [omerxx's tmux config](https://github.com/omerxx/dotfiles) taken
verbatim. It has since diverged where his assumptions were macOS-specific or where
a setting was dead on arrival — see the table below.

Theming is his catppuccin setup, driven by the `omerxx/catppuccin-tmux` fork (a
catppuccin v1 fork, last updated 2023-11-30). The `@catppuccin_*` block lives inline
in `tmux.conf` — there is no separate theme file, because he does not have one.

## Where it diverges from his

| Change | Why |
|---|---|
| `@plugin 'christoomey/vim-tmux-navigator'` | the one plugin we have that he does not |
| `@sessionx-custom-paths` → `~/dotfiles` | his value is a macOS path |
| `run '~/.config/tmux/plugins/tpm/tpm'` | **fatal otherwise** — his `~/.tmux/plugins/…` does not exist here, and TPM would load nothing |
| `set -g mouse on` | not his; restored because this setup had it before the swap |
| tmux-thumbs block (`@thumbs-*`) | not his; on `prefix + g`, and pushes picks to the Wayland clipboard via `wl-copy` |
| `default-terminal` → `tmux-256color` | see below |
| `terminal-features ',*:RGB'` | replaces his `terminal-overrides ',xterm-256color:RGB'` |
| three dead bindings dropped from `tmux.reset.conf` | see below |

### The terminal settings

His config ends up running `set -g default-terminal "${TERM}"`, which makes tmux
advertise the **outer** terminal's terminfo to programs inside a pane — here
`xterm-ghostty`. That is the same failure `.zshrc` documents avoiding from the
other direction: nvim then reads capabilities through tmux that the tmux layer
does not actually provide, and gets undercurl and italics wrong. It is now
`tmux-256color`, which is tmux's own terminfo and is installed.

Truecolor moved with it. `terminal-overrides ',xterm-256color:RGB'` was keyed on a
TERM name that is neither the outer terminal (`xterm-ghostty`) nor the inner one,
so it applied to nothing; `terminal-features ',*:RGB'` declares it for whatever is
actually outside.

### The dropped bindings

Three lines in his `tmux.reset.conf` could never fire, because a later line in the
same file rebound the same key: `bind * list-clients` (lost to
`setw synchronize-panes`), `bind l refresh-client` (lost to `select-pane -R`), and a
second identical `bind R source-file`. `prefix + |` also kept no cwd, unlike `s`
and `v`; it does now.

## Layout

```
tmux/
├── tmux.conf         # options, plugins, inline @catppuccin_* theme block
└── tmux.reset.conf   # keybinds, sourced first
```

Plugins are cloned into `plugins/` by TPM and are gitignored.

## Dependencies

| Tool | Required by |
|---|---|
| tmux ≥ 3.0 | catppuccin fork |
| `fzf` | sessionx, tmux-fzf, fzf-url |
| `zoxide` | sessionx (`@sessionx-zoxide-mode on`) |
| Rust toolchain | tmux-thumbs (builds its own binary on first run) |

## Plugins (12)

`tpm` · `tmux-sensible` · `tmux-yank` · `vim-tmux-navigator` · `tmux-resurrect`
`tmux-continuum` · `tmux-thumbs` · `tmux-fzf` · `tmux-fzf-url`
`omerxx/catppuccin-tmux` · `omerxx/tmux-sessionx` · `omerxx/tmux-floax`

`prefix + I` installs, `prefix + U` updates, `prefix + M-u` removes unused.

## Gotchas

These are his bindings, and they differ from stock tmux. Worth reading once.

- **`prefix + c` KILLS THE PANE.** In stock tmux `c` creates a window. Use
  **`prefix + Ctrl-c`** for a new window (opens in `$HOME`, not the current path).
- **`prefix + g` runs thumbs.** tmux-thumbs claims `prefix + Space` by default,
  which is tmux's own `next-layout`; `@thumbs-key g` moves it off. Space still
  cycles layouts, and `M-1..M-7` still pick them directly.
- **`prefix + P`** is floax's menu, not `pane-border-status` — floax overrides the
  binding in his reset file.
- `mouse on` is set — it is **not** in his config, added back because this setup
  had it before the swap.
- There is no `~/.tmux.local.conf` per-host hook, and no `allow-passthrough`,
  so **yazi image previews render blank inside tmux** — silently, no error.

## Key bindings

Prefix is **`Ctrl+A`**.

### Windows
| Key | Action |
|---|---|
| `prefix + Ctrl-c` | New window (in `$HOME`) |
| `prefix + c` | **Kill pane** — see Gotchas |
| `prefix + H` / `L` | Previous / next window |
| `prefix + n` / `Ctrl-n` | Next window |
| `prefix + Ctrl-p` | Previous window |
| `prefix + a` / `Ctrl-a` | Last window |
| `prefix + r` | Rename window |
| `prefix + w` / `Ctrl-w` | List windows |
| `prefix + f` | Find window |

### Panes
| Key | Action |
|---|---|
| `prefix + s` / `v` | Split vertical / horizontal (keeps cwd) |
| `prefix + \|` | Split (no cwd) |
| `prefix + h/j/k/l` | Select pane |
| `Ctrl + h/j/k/l` | Vim-aware nav, no prefix (vim-tmux-navigator) |
| `prefix + z` | Zoom pane |
| `prefix + x` | Swap pane down |
| `prefix + q` | Show pane numbers |
| `prefix + ,` / `.` | Resize left / right by 20 |
| `prefix + -` / `=` | Resize down / up by 7 |
| `prefix + M-1..M-7` | Preset layouts |
| `prefix + *` | Toggle synchronize-panes |

### Plugins
| Key | Action |
|---|---|
| `prefix + o` | sessionx — fuzzy session / project switcher |
| `prefix + p` | floax — floating shell pane |
| `prefix + P` | floax menu |
| `prefix + Space` | thumbs — hint-pick paths / SHAs / URLs |
| `prefix + u` | fzf-url — pick a URL from scrollback |
| `prefix + F` | tmux-fzf — general fzf menu |
| `prefix + y` / `Y` | yank line / pane cwd |
| `prefix + Ctrl-s` / `Ctrl-r` | resurrect save / restore |

### Session & misc
| Key | Action |
|---|---|
| `prefix + S` | Choose session |
| `prefix + D` | Choose client |
| `prefix + d` / `Ctrl-d` | Detach |
| `prefix + K` | Clear screen |
| `prefix + R` | Reload config |
| `prefix + Ctrl-x` | Lock server |

Copy mode is vi-style; `v` starts a selection.

## Sessions are restored automatically

`@continuum-restore 'on'` means tmux restores your previous sessions on server
start. Note `@resurrect-capture-pane-contents` is **not** set (his config does not
set it), so restored panes come back running but with empty scrollback.
