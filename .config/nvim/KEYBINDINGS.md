# Keybindings

**Leader**: `<Space>` (local leader is also `<Space>`)

Press `<leader>` and wait — which-key lists everything below, grouped.

---

## Core editing

| Key | Mode | Action |
|-----|------|--------|
| `jj` | Insert | Escape to normal mode |
| `E` | Normal | Go to end of line (`$`) |
| `B` | Normal | Go to beginning of line (`^`) |
| `j` / `k` | Normal | Move by screen line when no count is given |
| `WW` | Normal | Force write (`:w!`) |
| `QQ` | Normal | Force quit (`:q!`) |
| `<leader>qq` | Normal | Close window (`:q`) |
| `<leader>h` | Normal | Clear search highlight |
| `<leader>/` | Normal/Visual | Toggle comment |
| `gcc` / `gc` | Normal/Visual | Comment linewise |
| `gbc` / `gb` | Normal/Visual | Comment blockwise |

## Buffers & windows

| Key | Mode | Action |
|-----|------|--------|
| `th` / `tl` | Normal | Previous / next buffer |
| `tj` / `tk` | Normal | First / last buffer |
| `td` | Normal | Delete buffer |
| `<leader>bd` | Normal | Delete buffer (keeps the window) |
| `<leader>1` … `<leader>9` | Normal | Jump to bufferline tab N |
| `<leader>e` | Normal | File explorer (focus / close) |
| `<C-W>,` / `<C-W>.` | Normal | Shrink / grow split width |
| `<C-w>z` | Normal | Toggle window zoom |
| `<C-h/j/k/l>` | Normal | Move between splits and tmux panes |
| `<C-\>` | Normal | Previous tmux pane |

> `t` is a buffer-navigation prefix here, so `t{char}` (till-motion) is shadowed
> for `h`, `j`, `k`, `l`, `d` and `w`.

## Find (telescope)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ff` | Normal | Find files |
| `<leader>fg` | Normal | Live grep |
| `<leader>fb` | Normal | Find buffers |
| `<leader>fh` | Normal | Find help tags |
| `<leader>ft` | Normal | Find todos |
| `]t` / `[t` | Normal | Next / previous todo comment |

## LSP

| Key | Mode | Action |
|-----|------|--------|
| `gd` | Normal | Go to definition |
| `gD` | Normal | Go to declaration |
| `gi` | Normal | Go to implementation |
| `gr` | Normal | References |
| `K` | Normal | Hover docs |
| `<leader>k` | Normal | Signature help |
| `<leader>D` | Normal | Type definition |
| `<leader>rn` | Normal | Rename symbol |
| `<leader>ca` | Normal/Visual | Code action |
| `<leader>cF` | Normal | Format buffer (conform) |
| `<leader>cR` | Normal | Rename file |
| `<leader>wa` / `<leader>wr` / `<leader>wl` | Normal | Add / remove / list workspace folder |

Format-on-save is on; `<leader>cF` is for formatting on demand.

### Preview windows (goto-preview)

| Key | Mode | Action |
|-----|------|--------|
| `gpd` / `gpr` / `gpi` | Normal | Preview definition / references / implementation |
| `gP` | Normal | Close all preview windows |

### Diagnostics (trouble)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>xx` | Normal | Diagnostics |
| `<leader>xX` | Normal | Buffer diagnostics |
| `<leader>cs` | Normal | Document symbols |
| `<leader>cl` | Normal | LSP definitions / references panel |
| `<leader>xL` / `<leader>xQ` | Normal | Location list / quickfix list |

## Surround (mini.surround)

Moved off bare `s` so the builtin substitute-char still works.

| Key | Mode | Action |
|-----|------|--------|
| `gsa` | Normal/Visual | Add surrounding |
| `gsd` | Normal | Delete surrounding |
| `gsr` | Normal | Replace surrounding |
| `gsf` / `gsF` | Normal | Find surrounding right / left |
| `gsh` | Normal | Highlight surrounding |
| `gsn` | Normal | Update `n_lines` |

## Git

| Key | Mode | Action |
|-----|------|--------|
| `<leader>gg` | Normal | Lazygit |
| `<leader>gl` | Normal | Lazygit log (cwd) |
| `<leader>gf` | Normal | Lazygit log for current file |
| `<leader>gs` | Normal | Neogit status |
| `<leader>gc` | Normal | Neogit commit |
| `<leader>gp` | Normal | Neogit push |
| `<leader>gL` | Normal | Neogit log |
| `<leader>gb` | Normal | Blame line |
| `<leader>gB` | Normal | Open in browser |
| `<leader>gw` / `<leader>gW` | Normal | List / create git worktree |

## Debug (nvim-dap)

First press of any `<leader>d` key loads the debugger.

| Key | Mode | Action |
|-----|------|--------|
| `<leader>dt` | Normal | Toggle DAP UI |
| `<leader>db` / `<leader>dB` | Normal | Toggle / conditional breakpoint |
| `<leader>dc` | Normal | Continue or start |
| `<leader>dR` | Normal | Run last configuration |
| `<leader>ds` / `<leader>di` / `<leader>do` | Normal | Step over / into / out |
| `<leader>dr` | Normal | Open REPL |
| `<leader>dl` | Normal | List breakpoints |
| `<leader>de` | Normal | Break on exceptions |
| `<leader>dx` | Normal | Clear breakpoints |
| `<leader>dq` | Normal | Terminate session |

Adapters: codelldb (C/C++/Rust), debugpy (Python), delve (Go),
js-debug-adapter (JS/TS), php-debug-adapter.

## AI (opencode)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>at` | Normal | Toggle opencode |
| `<leader>aa` | Normal/Visual | Ask about cursor / selection |
| `<leader>a+` | Normal/Visual | Add buffer / selection to context |
| `<leader>ae` | Normal | Explain this |
| `<leader>an` | Normal | New session |
| `<leader>as` | Normal/Visual | Select a prompt |
| `<S-C-u>` / `<S-C-d>` | Normal | Scroll messages up / down |

## Notes & markdown

| Key | Mode | Action |
|-----|------|--------|
| `<leader>on` | Normal | Obsidian quick switcher |
| `<leader>os` | Normal | Search notes |
| `<leader>od` | Normal | Daily note |
| `<leader>nn` | Normal | New note |
| `<leader>ch` | Normal (in a note) | Toggle checkbox |
| `<CR>` | Normal (in a note) | Smart action: follow link / toggle checkbox |
| `]o` / `[o` | Normal (in a note) | Next / previous link |
| `<leader>mp` | Normal (markdown) | Toggle markdown preview |

Vault: `~/Resources/MSB`.

## Focus & UI

| Key | Mode | Action |
|-----|------|--------|
| `<leader>z` | Normal | Zen mode |
| `tw` | Normal | Twilight (dim inactive code) |
| `TT` | Normal | Toggle background transparency |
| `<leader>ut` | Normal | Undo tree |
| `<C-/>` or `<C-_>` | Normal | Toggle terminal |
| `]]` / `[[` | Normal/Terminal | Next / previous reference to word under cursor |
| `<leader>N` | Normal | Neovim news |

### Toggles (`<leader>u`)

| Key | Toggles |
|-----|---------|
| `<leader>un` | Dismiss notifications |
| `<leader>nd` | Dismiss noice messages |
| `<leader>us` | Spell check |
| `<leader>uw` | Line wrap |
| `<leader>ul` / `<leader>uL` | Line numbers / relative numbers |
| `<leader>ud` | Diagnostics |
| `<leader>uc` | Conceal level |
| `<leader>uT` | Treesitter highlighting |
| `<leader>ub` | Light / dark background |
| `<leader>uh` | Inlay hints |

## Screenshots & LeetCode

| Key | Mode | Action |
|-----|------|--------|
| `<leader>cs` | Visual | Code screenshot |
| `<leader>css` | Visual | Save code screenshot |
| `<leader>ll` | Normal | LeetCode problem list |
| `<leader>ld` | Normal | Problem description |
| `<leader>lr` / `<leader>lt` / `<leader>ls` | Normal | Run / test / submit |

## Completion (insert mode)

| Key | Action |
|-----|--------|
| `<C-Space>` | Trigger completion |
| `<C-n>` / `<C-p>` | Next / previous item |
| `<Tab>` / `<S-Tab>` | Next / previous item, or jump snippet placeholder |
| `<CR>` | Confirm |
| `<C-d>` / `<C-f>` | Scroll docs |
| `<C-e>` | Close menu |
