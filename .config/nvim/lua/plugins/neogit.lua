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
    keys = {
      { "<leader>gw", "<cmd>Telescope git_worktree git_worktrees<cr>", desc = "Git Worktrees" },
      { "<leader>gW", "<cmd>Telescope git_worktree create_git_worktree<cr>", desc = "Create Git Worktree" },
    },
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("git-worktree").setup()
      require("telescope").load_extension("git_worktree")
    end
  }
}
