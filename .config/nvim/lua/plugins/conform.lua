-- prettierd first, prettier as the fallback -- run one, not both.
local prettier = { "prettierd", "prettier", stop_after_first = true }

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
      format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        -- Both, in order: goimports fixes imports, then gofumpt restyles.
        go = { "goimports", "gofumpt" },
        python = { "ruff_format" },
        nix = { "alejandra" },
        templ = { "templ" },
        javascript = prettier,
        typescript = prettier,
        javascriptreact = prettier,
        typescriptreact = prettier,
        html = prettier,
        css = prettier,
        json = prettier,
        yaml = prettier,
        markdown = prettier,
      },
    },
  },
}
