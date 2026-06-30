return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main", -- native Neovim 0.11+/0.12 support (no query_predicates patch needed)
		lazy = false,    -- the main branch does not support lazy-loading
		build = ":TSUpdate",
		config = function()
			-- main branch installs parsers explicitly (no ensure_installed/auto_install).
			-- no-op for already-installed parsers; runs async.
			require("nvim-treesitter").install({
				"lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
				"python", "c", "cpp", "bash", "json", "yaml", "toml",
				"regex", "diff", "html", "css", "scss", "javascript", "typescript",
				"tsx", "svelte", "gleam",
			})

			-- Start TS highlighting + indentation for a buffer when a parser exists.
			local function enable(buf)
				local ft = vim.bo[buf].filetype
				if ft == "" then return end
				local lang = vim.treesitter.language.get_lang(ft) or ft
				if pcall(vim.treesitter.start, buf, lang) then
					vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end

			vim.api.nvim_create_autocmd("FileType", {
				desc = "Start treesitter highlighting + indent",
				callback = function(ev) enable(ev.buf) end,
			})

			-- Catch buffers already open at startup (files passed on the cmdline),
			-- whose FileType fired before this config ran.
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(buf) then enable(buf) end
			end
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = true,           -- Auto close tags
					enable_rename = true,          -- Auto rename pairs of tags
					enable_close_on_slash = false, -- Auto close on trailing </
				},
				aliases = {
					["template"] = "html",
				},
			})
		end,
	},
}
