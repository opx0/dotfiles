return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = { "echasnovski/mini.icons" },
    config = function()
      -- Bufferline wants the nvim-web-devicons API; mini.icons can provide it.
      require("mini.icons").mock_nvim_web_devicons()

      require("bufferline").setup({
        options = {
          mode = "buffers",
          diagnostics = "nvim_lsp",
          separator_style = "thin",
          show_buffer_close_icons = true,
          show_close_icon = false,
          always_show_bufferline = true,
          -- Responsive to the neo-tree sidebar: indent the tabs to start at the
          -- editor and show a header above the tree (shifts as neo-tree opens/closes).
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "left",
              separator = true,
            },
          },
        },
        -- Match catppuccin + transparency (integration reads transparent_background)
        highlights = require("catppuccin.special.bufferline").get_theme(),
      })

      -- Jump straight to tab N (VS Code style). th/tl still cycle.
      for i = 1, 9 do
        vim.keymap.set("n", "<leader>" .. i, function()
          require("bufferline").go_to(i, true)
        end, { desc = "Go to tab " .. i })
      end
    end,
  },
}
