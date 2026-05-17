return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {},
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	config = function()
		vim.keymap.set("n", "<space>o", require("oil").toggle_float)
		require("oil").setup({
			keymaps = {
				["q"] = {
					desc = "Close oil (discard pending changes)",
					callback = function()
						vim.bo.modified = false
						require("oil.actions").close.callback()
					end,
					mode = "n",
				},
			},
		})
	end,
}
