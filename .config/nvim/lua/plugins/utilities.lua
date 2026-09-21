return {
  -- Todo comments highlighting
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("todo-comments").setup()

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
    keys = {
      { "gpd", function() require("goto-preview").goto_preview_definition() end, desc = "Preview definition" },
      { "gpr", function() require("goto-preview").goto_preview_references() end, desc = "Preview references" },
      { "gpi", function() require("goto-preview").goto_preview_implementation() end, desc = "Preview implementation" },
      { "gP", function() require("goto-preview").close_all_win() end, desc = "Close all preview windows" },
    },
    opts = function()
      return {
        width = 120,
        height = 15,
        border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" },
        default_mappings = false,
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
    end,
  },

  {
    'echasnovski/mini.ai',
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    'echasnovski/mini.surround',
    keys = { "gsa", "gsd", "gsr", "gsf", "gsF", "gsh", "gsn", { "gsa", mode = "v" } },
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
        suffix_last = "l",
        suffix_next = "n",
      },
    },
  },
  {
    'echasnovski/mini.indentscope',
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  -- Session management
  {
    'tpope/vim-obsession',
    cmd = { "Obsess", "Obsession" },
  }
}
