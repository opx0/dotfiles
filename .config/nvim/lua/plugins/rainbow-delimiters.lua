return {
  "HiPhish/rainbow-delimiters.nvim",
  event = "VeryLazy",
  init = function()
    vim.g.rainbow_delimiters = {
      condition = function(bufnr)
        local ft = vim.bo[bufnr].filetype
        if ft == nil or ft == "" then
          return false
        end

        local ok = pcall(vim.treesitter.get_parser, bufnr, ft)
        return ok
      end,
    }
  end,
}
