return {
	{
		"folke/which-key.nvim",
		keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
		cmd = "WhichKey",
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			wk.add({
				-- File operations
				{ "<leader>f", group = "Find" },
				{ "<leader>ff", desc = "Find Files" },
				{ "<leader>fg", desc = "Live Grep" },
				{ "<leader>fb", desc = "Find Buffers" },
				{ "<leader>fh", desc = "Find Help" },
				{ "<leader>ft", desc = "Find Todos" },

				-- Git operations
				{ "<leader>g", group = "Git" },
				{ "<leader>gg", desc = "Lazygit" },
				{ "<leader>gs", desc = "Git Status (Neogit)" },
				{ "<leader>gc", desc = "Git Commit" },
				{ "<leader>gp", desc = "Git Push" },
				{ "<leader>gl", desc = "Git Log" },
				{ "<leader>gb", desc = "Git Blame Line" },
				{ "<leader>gB", desc = "Git Browse" },
				{ "<leader>gf", desc = "Git File History" },

				-- Debug operations
				{ "<leader>d", group = "Debug" },
				{ "<leader>dt", desc = "Toggle DAP UI" },
				{ "<leader>db", desc = "Toggle Breakpoint" },
				{ "<leader>dc", desc = "Continue" },
				{ "<leader>dr", desc = "Reset DAP UI" },
				{ "<leader>ds", desc = "Step Over" },
				{ "<leader>di", desc = "Step Into" },
				{ "<leader>do", desc = "Step Out" },

				-- Harpoon
				{ "<leader>h", group = "Harpoon" },
				{ "<leader>m", desc = "Add File to Harpoon" },
				{ "<leader>ht", desc = "Toggle Harpoon Menu" },
				{ "<leader>sh", desc = "Search Harpoon Files" },

				-- LSP operations
				{ "<leader>c", group = "Code" },
				{ "<leader>ca", desc = "Code Action" },
				{ "<leader>cR", desc = "Rename File" },
				{ "<leader>rn", desc = "Rename Symbol" },
				{ "<leader>wa", desc = "Add Workspace Folder" },
				{ "<leader>wr", desc = "Remove Workspace Folder" },
				{ "<leader>wl", desc = "List Workspace Folders" },

				-- Utilities
				{ "<leader>u", group = "UI/Utils" },
				{ "<leader>un", desc = "Dismiss Notifications" },
				{ "<leader>us", desc = "Toggle Spelling" },
				{ "<leader>uw", desc = "Toggle Wrap" },
				{ "<leader>uL", desc = "Toggle Relative Numbers" },
				{ "<leader>ud", desc = "Toggle Diagnostics" },
				{ "<leader>ul", desc = "Toggle Line Numbers" },
				{ "<leader>uc", desc = "Toggle Conceal Level" },
				{ "<leader>uT", desc = "Toggle Treesitter" },
				{ "<leader>ub", desc = "Toggle Background" },
				{ "<leader>uh", desc = "Toggle Inlay Hints" },

				-- Other
				{ "<leader>z", desc = "Toggle Zen Mode" },
				{ "<leader>qq", desc = "Quit" },
				{ "<leader>bd", desc = "Delete Buffer" },
				{ "<leader>nn", desc = "Dismiss Noice" },
				{ "<leader>N", desc = "Neovim News" },
				{ "<leader>ch", desc = "Toggle Checkbox" },

				-- Code screenshots
				{ "<leader>cs", desc = "Code Screenshot", mode = "v" },
				{ "<leader>css", desc = "Save Code Screenshot", mode = "v" },

				-- Preview operations
				{ "gp", group = "Preview" },
				{ "gpd", desc = "Preview Definition" },
				{ "gpr", desc = "Preview References" },
				{ "gpi", desc = "Preview Implementation" },
				{ "gP", desc = "Close All Previews" },

				-- Todo navigation
				{ "]t", desc = "Next Todo" },
				{ "[t", desc = "Previous Todo" },
			})
		end,
	},
}
