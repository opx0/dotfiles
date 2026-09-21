# nvim

Personal Neovim configuration. Requires **Neovim 0.11+** (uses the native
`vim.lsp.config` / `vim.lsp.enable` API); developed on 0.12.

## Layout

```
init.lua                 core options + core keymaps, bootstraps lazy.nvim
lua/plugins/*.lua        one file per plugin (or per closely-related group)
lua/plugins/configs/     larger option tables pulled out of the specs
lazy-lock.json           pinned plugin revisions
KEYBINDINGS.md           full keymap reference
```

`require("lazy").setup("plugins")` picks up every file under `lua/plugins/`
automatically — adding a plugin means adding a file.

## What's in it

| Area | Plugins |
|---|---|
| Plugin manager | lazy.nvim |
| Completion | nvim-cmp, LuaSnip, friendly-snippets, nvim-autopairs |
| LSP | native `vim.lsp` + nvim-lspconfig defaults, mason for binaries, fidget for progress |
| Formatting | conform.nvim (format-on-save) |
| Syntax | nvim-treesitter (`main` branch), nvim-ts-autotag, rainbow-delimiters |
| Finding | telescope.nvim, todo-comments |
| Explorer / tabs | neo-tree, bufferline |
| Git | neogit, gitsigns, diffview, fugitive, git-worktree, lazygit via snacks |
| Debugging | nvim-dap + dap-ui + dap-virtual-text, mason-nvim-dap |
| UI | catppuccin (mocha, transparent), lualine, noice, snacks |
| Editing | Comment.nvim, mini.ai, mini.surround, mini.indentscope, trim, vim-sleuth |
| Notes | obsidian.nvim, render-markdown, markdown-preview, vim-pencil |
| Focus | zen-mode, twilight |
| Misc | opencode.nvim, leetcode.nvim, undotree, codesnap, wakatime |

## Language support

Servers are enabled in `lua/plugins/lspconfig.lua` and their binaries are
installed by mason from `lua/plugins/configs/mason.lua`:

`lua_ls` · `gopls` · `ts_ls` · `html` · `tailwindcss` · `htmx`

Formatters (conform, `lua/plugins/conform.lua`):

`stylua` · `goimports` + `gofumpt` · `ruff_format` · `prettierd`/`prettier` ·
`alejandra` · `templ`

Adding a language means adding it in **all three** places: the mason list, the
`vim.lsp.enable` list, and — if it has a formatter — `formatters_by_ft`.

The nix language server (`nil`) is intentionally not installed: mason builds it
from source and its build script requires the `nix` binary, which isn't present
on this machine. `.nix` files still format via `alejandra`.

## Loading

Startup is ~17 ms. Almost everything is deferred; what loads eagerly is only
what has to:

- **snacks.nvim** — owns the dashboard, so it can't wait
- **nvim-treesitter** (`main` branch doesn't support lazy-loading)
- **catppuccin** — the colorscheme
- **nvim-lspconfig**, **conform**, **mini.ai/indentscope**, **todo-comments** —
  all on `BufReadPre`/`BufNewFile`, so not on an empty start

Everything else waits for a key, a command, a filetype or `VeryLazy`.

## Maintenance

```bash
:Lazy              # plugin status / install / update
:Mason             # language server + tool status
:MasonToolsInstall # install anything missing from configs/mason.lua
:checkhealth       # diagnose
```

`:Lazy update` rewrites `lazy-lock.json`; commit it to keep machines in sync.
