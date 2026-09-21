return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			-- Kept in a local so the TT toggle can flip one field and re-apply
			-- the *whole* table -- calling setup() with a partial one resets
			-- every other option to its default.
			local opts = {
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				background = { -- :h background
					light = "latte",
					dark = "mocha",
				},
				transparent_background = true,
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
					notify = true,
					mini = true,
					telescope = {
						enabled = true,
					},
					neotree = true,
					mason = true,
					noice = true,
					which_key = true,
				},
			}

			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin")

			vim.keymap.set("n", "TT", function()
				opts.transparent_background = not opts.transparent_background
				require("catppuccin").setup(opts)
				vim.cmd.colorscheme("catppuccin")
			end, { desc = "Toggle transparency" })
		end,
	},

	{ "folke/tokyonight.nvim", name = "tokyonight", lazy = true },
	{ "rose-pine/neovim", name = "rose-pine", lazy = true },
}
