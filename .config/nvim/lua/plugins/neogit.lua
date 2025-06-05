return {
  {
    "NeogitOrg/neogit",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = function()
      require('neogit').setup()

      -- Keymaps
      vim.keymap.set("n", "<leader>gs", "<cmd>Neogit<cr>", { desc = "Open Neogit" })
      vim.keymap.set("n", "<leader>gc", "<cmd>Neogit commit<cr>", { desc = "Git commit" })
      vim.keymap.set("n", "<leader>gp", "<cmd>Neogit push<cr>", { desc = "Git push" })
      vim.keymap.set("n", "<leader>gl", "<cmd>Neogit log<cr>", { desc = "Git log" })
    end
  },

  -- Additional git tools
  {
    'tpope/vim-fugitive',
    cmd = { "Git", "Gwrite", "Gread", "Ggrep", "GMove", "GDelete", "GBrowse", "GRemove" },
  },

  {
    'ThePrimeagen/git-worktree.nvim',
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("git-worktree").setup()
      require("telescope").load_extension("git_worktree")
    end
  }
}
