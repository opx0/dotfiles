return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				background = { -- :h background
					light = "latte",
					dark = "mocha",
				},
				transparent_background = true,
				show_end_of_buffer = false,
				term_colors = false,
				dim_inactive = {
					enabled = false,
					shade = "dark",
					percentage = 0.15,
				},
				no_italic = false,
				no_bold = false,
				no_underline = false,
				styles = {
					comments = { "italic" },
					conditionals = { "italic" },
					loops = {},
					functions = {},
					keywords = {},
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
				},
				color_overrides = {},
				custom_highlights = {},
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					treesitter = true,
					notify = true,
					mini = true,
					telescope = {
						enabled = true,
					},
					harpoon = true,
					mason = true,
					noice = true,
					which_key = true,
				},
			})

			vim.cmd.colorscheme("catppuccin")

			-- Transparency toggle
			vim.keymap.set("n", "TT", ":TransparentToggle<CR>", {
				noremap = true,
				desc = "Toggle transparency"
			})
		end,
	},

	-- Transparency plugin
	{
		"xiyaowong/transparent.nvim",
		config = function()
			require("transparent").setup({
				groups = {
					'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
					'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
					'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'Tree',
					'NonText', 'SignColumn', 'CursorLineNr', 'EndOfBuffer',
				},
				extra_groups = {},
				exclude_groups = {},
			})
		end
	},

	-- Alternative colorschemes
	{
		"folke/tokyonight.nvim",
		name = "tokyonight",
		priority = 900,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 900,
	},
}
