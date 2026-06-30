-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.scrolloff = 3

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

local autocmd = vim.api.nvim_create_autocmd

vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
	pattern = { "*.templ" },
	callback = function()
		vim.bo[vim.api.nvim_get_current_buf()].filetype = "templ"
	end,
})

vim.opt.rtp:prepend(lazypath)

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.o.relativenumber = true -- Add relative line numbers

-- Tabs vs spaces
vim.o.tabstop = 2 -- A TAB character looks like 2 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 2 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 2 -- Number of spaces inserted when indenting

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- Set terminal gui colors to true
vim.o.termguicolors = true

-- Concealer for markdown/obsidian
vim.o.conceallevel = 2

-- Add quick escape mapping
vim.keymap.set("i", "jj", "<Esc>", { desc = "Quick escape" })

-- Basic navigation improvements
vim.keymap.set("n", "E", "$", { desc = "Go to end of line" })
vim.keymap.set("n", "B", "^", { desc = "Go to beginning of line" })

-- Clear search highlighting
vim.keymap.set('n', '<leader>h', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Better split resizing
vim.keymap.set("n", "<C-W>,", ":vertical resize -10<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-W>.", ":vertical resize +10<CR>", { desc = "Increase window width" })

-- Quick save and quit
vim.keymap.set("n", "QQ", ":q!<CR>", { desc = "Force quit" })
vim.keymap.set("n", "WW", ":w!<CR>", { desc = "Force write" })

-- Buffer navigation
vim.keymap.set("n", "tk", ":blast<CR>", { desc = "Go to last buffer" })
vim.keymap.set("n", "tj", ":bfirst<CR>", { desc = "Go to first buffer" })
vim.keymap.set("n", "th", ":bprev<CR>", { desc = "Go to previous buffer" })
vim.keymap.set("n", "tl", ":bnext<CR>", { desc = "Go to next buffer" })
vim.keymap.set("n", "td", ":bdelete<CR>", { desc = "Delete buffer" })

-- Better word wrap navigation
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Quick close split
vim.keymap.set("n", "<leader>qq", ":q<CR>", {silent = true, noremap = true})

-- add binaries installed by mason.nvim to path
local is_windows = vim.uv.os_uname().sysname == "Windows_NT"
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH

require("lazy").setup("plugins")
