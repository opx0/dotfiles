return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cF",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        desc = "Format Buffer",
      },
    },
    opts = {
      notify_on_error = true,
      -- Run the first AVAILABLE formatter per filetype (replaces the old, now
      -- removed, nested `{ { "a", "b" } }` syntax).
      stop_after_first = true,
      format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "goimports", "gofumpt" },
        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        python = { "ruff_format" },
        nix = { "alejandra" },
        html = { "prettierd", "prettier" },
        css = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        yaml = { "prettierd", "prettier" },
        markdown = { "prettierd", "prettier" },
        templ = { "templ" },
      },
    },
  },
}
