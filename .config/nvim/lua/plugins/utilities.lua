return {
  -- Todo comments highlighting
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("todo-comments").setup()

      -- Keymaps
      vim.keymap.set("n", "]t", function()
        require("todo-comments").jump_next()
      end, { desc = "Next todo comment" })

      vim.keymap.set("n", "[t", function()
        require("todo-comments").jump_prev()
      end, { desc = "Previous todo comment" })

      vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
    end
  },

  -- Goto preview for definitions/references
  {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup {
        width = 120,
        height = 15,
        border = {"↖", "─" ,"┐", "│", "┘", "─", "└", "│"},
        default_mappings = true,
        debug = false,
        opacity = nil,
        resizing_mappings = false,
        post_open_hook = nil,
        references = {
          telescope = require("telescope.themes").get_dropdown({ hide_preview = false })
        },
        focus_on_open = true,
        dismiss_on_move = false,
        force_close = true,
        bufhidden = "wipe",
        stack_floating_preview_windows = true,
        preview_window_title = { enable = true, position = "left" },
      }

      -- Keymaps
      vim.keymap.set("n", "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", { desc = "Preview definition" })
      vim.keymap.set("n", "gpr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>", { desc = "Preview references" })
      vim.keymap.set("n", "gpi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", { desc = "Preview implementation" })
      vim.keymap.set("n", "gP", "<cmd>lua require('goto-preview').close_all_win()<CR>", { desc = "Close all preview windows" })
    end
  },

	-- Mini.nvim collection
	{
		'echasnovski/mini.nvim',
		version = false,
		config = function()
			-- Mini.ai for better text objects
			require('mini.ai').setup()

			-- Mini.surround for surrounding text objects
			require('mini.surround').setup()

			-- NOTE: autopairs is handled by nvim-autopairs (cmp.lua) and comments
			-- by Comment.nvim (comment.lua); mini.pairs/mini.comment removed to
			-- avoid two plugins fighting over the same keys.

			-- Mini.indentscope for indent guides
			require('mini.indentscope').setup()

			-- Window zoom toggle (<C-w>z)
			local zoomed = false
			vim.keymap.set("n", "<C-w>z", function()
				if zoomed then
					vim.cmd("wincmd =")
					zoomed = false
				else
					vim.cmd("wincmd _ | wincmd |")
					zoomed = true
				end
			end, { desc = "Toggle zoom" })
		end
	},

  -- Session management
  {
    'tpope/vim-obsession',
    cmd = { "Obsess", "Obsession" },
  }
}
