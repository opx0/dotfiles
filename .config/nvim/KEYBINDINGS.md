# nvim Keybindings Reference
## Leader Key
- **Leader**: `<Space>` (spacebar)
- **Local Leader**: `<Space>` (spacebar)
---

## 🚀 Essential Quick Keys
### Basic Navigation
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `jj` | Insert | `<Esc>` | Quick escape to normal mode |
| `E` | Normal | `$` | Move to end of line |
| `B` | Normal | `^` | Move to beginning of line |
| `k` | Normal | `gk` (if no count) | Move up (respects word wrap) |
| `j` | Normal | `gj` (if no count) | Move down (respects word wrap) |

### Quick Actions
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `ss` | Normal | `:noh<CR>` | Clear search highlighting |
| `<Space><Space>` | Normal | `:set nohlsearch<CR>` | Clear search highlighting |
| `WW` | Normal | `:w!` | Force save |
| `QQ` | Normal | `:q!` | Force quit |
| `TT` | Normal | `:TransparentToggle<CR>` | Toggle transparency |

---

## 📂 File & Buffer Management

### File Operations
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>ff` | Normal | `telescope.find_files` | Find files |
| `<leader>fg` | Normal | `telescope.live_grep` | Live grep search |
| `<leader>fb` | Normal | `telescope.buffers` | Find buffers |
| `<leader>fh` | Normal | `telescope.help_tags` | Find help |
| `<leader>ft` | Normal | `TodoTelescope` | Find todos |

### File Explorers
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<Space>o` | Normal | `oil.toggle_float` | Toggle Oil file manager |

### Buffer Navigation
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `th` | Normal | `:bprev` | Previous buffer |
| `tl` | Normal | `:bnext` | Next buffer |
| `tj` | Normal | `:bfirst` | First buffer |
| `tk` | Normal | `:blast` | Last buffer |
| `td` | Normal | `:bdelete` | Delete buffer |
| `<leader>bd` | Normal | `Snacks.bufdelete()` | Smart delete buffer |

---

## 🪟 Window Management

### Split Controls
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<C-W>,` | Normal | `:vertical resize -10` | Decrease split width |
| `<C-W>.` | Normal | `:vertical resize +10` | Increase split width |
| `<leader>qq` | Normal | `:q` | Close current split/window |

### Tmux Integration
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<C-h>` | Normal | `TmuxNavigateLeft` | Navigate left (tmux aware) |
| `<C-j>` | Normal | `TmuxNavigateDown` | Navigate down (tmux aware) |
| `<C-k>` | Normal | `TmuxNavigateUp` | Navigate up (tmux aware) |
| `<C-l>` | Normal | `TmuxNavigateRight` | Navigate right (tmux aware) |
| `<C-\>` | Normal | `TmuxNavigatePrevious` | Navigate to previous pane |

---

## 🏹 Harpoon (Quick File Navigation)

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>m` | Normal | `harpoon:list():add()` | Add file to harpoon |
| `<leader>ht` | Normal | `harpoon.ui:toggle_quick_menu()` | Toggle harpoon menu |
| `<leader>sh` | Normal | `telescope harpoon` | Search harpoon files |

---

## 🔧 LSP & Development

### LSP Navigation
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `gd` | Normal | `vim.lsp.buf.definition` | Go to definition |
| `gD` | Normal | `vim.lsp.buf.declaration` | Go to declaration |
| `gi` | Normal | `vim.lsp.buf.implementation` | Go to implementation |
| `gr` | Normal | `vim.lsp.buf.references` | Go to references |
| `K` | Normal | `vim.lsp.buf.hover` | Show hover documentation |
| `<C-k>` | Normal | `vim.lsp.buf.signature_help` | Show signature help |

### LSP Actions
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>ca` | Normal/Visual | `vim.lsp.buf.code_action` | Code actions |
| `<leader>rn` | Normal | `vim.lsp.buf.rename` | Rename symbol |
| `<leader>f` | Normal | `vim.lsp.buf.format` | Format document |
| `<leader>D` | Normal | `vim.lsp.buf.type_definition` | Type definition |

### LSP Workspace
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>wa` | Normal | `vim.lsp.buf.add_workspace_folder` | Add workspace folder |
| `<leader>wr` | Normal | `vim.lsp.buf.remove_workspace_folder` | Remove workspace folder |
| `<leader>wl` | Normal | List workspace folders | List workspace folders |

### Preview Functions
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `gpd` | Normal | `goto_preview_definition` | Preview definition |
| `gpr` | Normal | `goto_preview_references` | Preview references |
| `gpi` | Normal | `goto_preview_implementation` | Preview implementation |
| `gP` | Normal | `close_all_win` | Close all preview windows |

---

## 🐛 Debugging (DAP)

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>dt` | Normal | `dapui.toggle()` | Toggle DAP UI |
| `<leader>db` | Normal | `dap.toggle_breakpoint()` | Toggle breakpoint |
| `<leader>dc` | Normal | `dap.continue()` | Continue debugging |
| `<leader>dr` | Normal | `dapui.open({reset = true})` | Reset DAP UI |
| `<leader>ds` | Normal | `dap.step_over()` | Step over |
| `<leader>di` | Normal | `dap.step_into()` | Step into |
| `<leader>do` | Normal | `dap.step_out()` | Step out |

---

## 🔀 Git Operations

### Basic Git
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>gg` | Normal | `Snacks.lazygit()` | Open Lazygit |
| `<leader>gs` | Normal | `Neogit` | Git status (Neogit) |
| `<leader>gc` | Normal | `Neogit commit` | Git commit |
| `<leader>gp` | Normal | `Neogit push` | Git push |
| `<leader>gl` | Normal | `Snacks.lazygit.log()` | Git log |

### Git Information
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>gb` | Normal | `Snacks.git.blame_line()` | Git blame line |
| `<leader>gB` | Normal | `Snacks.gitbrowse()` | Git browse |
| `<leader>gf` | Normal | `Snacks.lazygit.log_file()` | File history |

---

## 🎯 Focus & Writing Tools

### Zen Mode & Focus
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>z` | Normal | `ZenMode` | Toggle zen mode |
| `tw` | Normal | `Twilight` | Toggle twilight (dim code) |

### Markdown & Notes
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>ch` | Normal | `toggle_checkbox` | Toggle checkbox (Obsidian) |

---

## 📸 Utilities

### Code Screenshots
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>cs` | Visual | `CodeSnap` | Take code screenshot |
| `<leader>css` | Visual | `CodeSnapSave` | Save code screenshot |

### Todo Comments
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `]t` | Normal | Next todo comment | Jump to next todo |
| `[t` | Normal | Previous todo comment | Jump to previous todo |

---

## 🔧 Trouble (Diagnostics)

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>xx` | Normal | `Trouble diagnostics toggle` | Toggle diagnostics |
| `<leader>xX` | Normal | `Trouble diagnostics toggle filter.buf=0` | Buffer diagnostics |
| `<leader>cs` | Normal | `Trouble symbols toggle` | Toggle symbols |
| `<leader>cl` | Normal | `Trouble lsp toggle` | LSP definitions/references |
| `<leader>xL` | Normal | `Trouble loclist toggle` | Location list |
| `<leader>xQ` | Normal | `Trouble qflist toggle` | Quickfix list |

---

## 🛠️ UI & Settings Toggles

### Snacks.nvim Toggles
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>us` | Normal | Toggle spelling | Enable/disable spell check |
| `<leader>uw` | Normal | Toggle wrap | Enable/disable line wrap |
| `<leader>uL` | Normal | Toggle relative numbers | Relative line numbers |
| `<leader>ud` | Normal | Toggle diagnostics | LSP diagnostics |
| `<leader>ul` | Normal | Toggle line numbers | Line numbers |
| `<leader>uc` | Normal | Toggle conceal level | Concealment |
| `<leader>uT` | Normal | Toggle treesitter | Treesitter highlighting |
| `<leader>ub` | Normal | Toggle background | Light/dark background |
| `<leader>uh` | Normal | Toggle inlay hints | LSP inlay hints |

### Notifications
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>un` | Normal | `Snacks.notifier.hide()` | Dismiss notifications |
| `<leader>nn` | Normal | `Noice dismiss` | Dismiss Noice messages |

---

## 🖥️ Terminal & System

### Terminal
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<C-/>` | Normal | `Snacks.terminal()` | Toggle terminal |
| `<C-_>` | Normal | `Snacks.terminal()` | Toggle terminal (alternative) |

### File Operations
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>cR` | Normal | `Snacks.rename.rename_file()` | Rename file |

---

## 📚 Reference Navigation

### Word & Reference Jumping
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `]]` | Normal/Terminal | `Snacks.words.jump(1)` | Next reference |
| `[[` | Normal/Terminal | `Snacks.words.jump(-1)` | Previous reference |

### Help & Documentation
| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `<leader>N` | Normal | Neovim News | Show Neovim news |

---

## 🎨 Themes & Appearance

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `TT` | Normal | `TransparentToggle` | Toggle transparency |

---

## 📋 Summary by Category

### Most Used Keys
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<Space>o` - File manager
- `<leader>gg` - Git operations
- `<leader>dt` - Debug
- `gd` - Go to definition
- `<leader>ca` - Code actions
- `jj` - Quick escape

### Quick Reference Groups
- **File**: `<leader>f*` - All file operations
- **Git**: `<leader>g*` - All git operations
- **Debug**: `<leader>d*` - All debug operations
- **LSP**: `g*` - Go to operations
- **UI**: `<leader>u*` - Toggle UI elements
- **Buffer**: `t*` - Buffer navigation

---

## 🔍 Which-Key Integration

Press `<leader>` and wait to see all available commands organized by category. The which-key plugin provides real-time discovery of all available keybindings with descriptions.

### Main Groups
- `<leader>f` - **Find**: File operations and search
- `<leader>g` - **Git**: Git operations and tools
- `<leader>d` - **Debug**: Debugging operations
- `<leader>c` - **Code**: LSP and code operations
- `<leader>u` - **UI/Utils**: Toggle UI elements
- `<leader>x` - **Trouble**: Diagnostics and trouble
- `<leader>h` - **Harpoon**: Quick file navigation

---

## 💡 Tips

1. **Start with which-key**: Press `<leader>` and explore available commands
2. **Telescope is your friend**: Most finding operations use `<leader>f*`
3. **Git workflow**: Use `<leader>gg` for interactive git operations
4. **Quick navigation**: Use Harpoon (`<leader>m`, `<leader>ht`) for frequently accessed files
5. **LSP navigation**: `gd`, `gr`, `gi` are your main navigation keys
6. **Focus mode**: Use `<leader>z` for distraction-free coding

This reference covers all keybindings in your nvimx configuration. Keep this handy while you learn the configuration!
