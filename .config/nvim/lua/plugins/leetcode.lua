return {
  {
    "kawre/leetcode.nvim",
    cmd = { "Leet" },
    opts = {
      lang = "python",
      inject = true,
      cn = {
        enabled = false,
      },
      storage = {
        home = vim.fn.stdpath("data") .. "/leetcode",
      },
      keys = {
        toggle = { "q" },
        confirm = { "<CR>" },
      },
      description = {
        width = 60,
      },
      console = {
        open_on_run = true,
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      { "<leader>ll", "<cmd>Leet list<CR>", desc = "LeetCode List" },
      { "<leader>lt", "<cmd>Leet test<CR>", desc = "LeetCode Test" },
      { "<leader>ls", "<cmd>Leet submit<CR>", desc = "LeetCode Submit" },
      { "<leader>lr", "<cmd>Leet run<CR>", desc = "LeetCode Run" },
      { "<leader>ld", "<cmd>Leet description<CR>", desc = "LeetCode Description" },
    },
  },
}
