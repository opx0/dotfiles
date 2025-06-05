return {
  -- LSP progress indicator
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      notification = {
        window = {
          winblend = 100,
        },
      },
    },
  },

  -- Better diagnostics
  {
    "folke/trouble.nvim",
    lazy = false,
    cmd = { "Trouble", "TroubleToggle" },
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
    config = function()
      require("trouble").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
      })
    end
  }
}
