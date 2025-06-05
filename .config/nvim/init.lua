-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.scrolloff = 3

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.g.lua_snippets_path = vim.fn.stdpath("config") .. "/lua/snippets/"
vim.cmd("au BufRead,BufNewFile *.templ setfiletype templ")
local autocmd = vim.api.nvim_create_autocmd

vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
	pattern = { "*.templ" },
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_set_option(buf, "filetype", "templ")
	end,
})

vim.opt.rtp:prepend(lazypath)

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.o.relativenumber = true -- Add relative line numbers

-- Tabs vs spaces
vim.o.tabstop = 2 -- A TAB character looks like 4 spaces
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
vim.api.nvim_set_keymap("i", "jj", "<Esc>", {noremap = false})

-- Basic navigation improvements
vim.api.nvim_set_keymap("n", "E", "$", {noremap = false})
vim.api.nvim_set_keymap("n", "B", "^", {noremap = false})

-- Clear search highlighting
vim.api.nvim_set_keymap("n", "ss", ":noh<CR>", {noremap = true})
vim.keymap.set('n', '<space><space>', "<cmd>set nohlsearch<CR>")

-- Better split resizing
vim.api.nvim_set_keymap("n", "<C-W>,", ":vertical resize -10<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<C-W>.", ":vertical resize +10<CR>", {noremap = true})

-- Quick save and quit
vim.api.nvim_set_keymap("n", "QQ", ":q!<enter>", {noremap = false})
vim.api.nvim_set_keymap("n", "WW", ":w!<enter>", {noremap = false})

-- Buffer navigation
vim.api.nvim_set_keymap("n", "tk", ":blast<enter>", {noremap = false})
vim.api.nvim_set_keymap("n", "tj", ":bfirst<enter>", {noremap = false})
vim.api.nvim_set_keymap("n", "th", ":bprev<enter>", {noremap = false})
vim.api.nvim_set_keymap("n", "tl", ":bnext<enter>", {noremap = false})
vim.api.nvim_set_keymap("n", "td", ":bdelete<enter>", {noremap = false})

-- Better word wrap navigation
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Quick close split
vim.keymap.set("n", "<leader>qq", ":q<CR>", {silent = true, noremap = true})

-- add binaries installed by mason.nvim to path
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH

require("lazy").setup("plugins")
