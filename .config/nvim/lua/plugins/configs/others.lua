local M = {}

M.luasnip = function(opts)
	require("luasnip").config.set_config(opts)

	-- vscode format
	require("luasnip.loaders.from_vscode").lazy_load()

	-- snipmate format
	require("luasnip.loaders.from_snipmate").load()

	-- lua format
	require("luasnip.loaders.from_lua").load()

	vim.api.nvim_create_autocmd("InsertLeave", {
		callback = function()
			if
				require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
				and not require("luasnip").session.jump_active
			then
				require("luasnip").unlink_current()
			end
		end,
	})
end

M.gitsigns = {
	signs = {
		add = { text = "│" },
		change = { text = "│" },
		delete = { text = "󰍵" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "│" },
	},
}

return M
