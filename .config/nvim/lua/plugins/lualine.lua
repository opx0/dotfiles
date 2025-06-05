return {
  {
    'nvim-lualine/lualine.nvim',
    event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = '|',
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_x = {
          function()
            return vim.loop.os_uname().sysname == "Linux" and "󰣇" or "󰌽"
          end,
        },
      },
    },
  },
}
