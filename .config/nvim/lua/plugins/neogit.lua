return {
  {
    "NeogitOrg/neogit",
    keys = {
      { "<leader>gs", "<cmd>Neogit<cr>", desc = "Open Neogit" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Git commit" },
      { "<leader>gp", "<cmd>Neogit push<cr>", desc = "Git push" },
      { "<leader>gL", "<cmd>Neogit log<cr>", desc = "Git log (Neogit)" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = function()
      require('neogit').setup()
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
