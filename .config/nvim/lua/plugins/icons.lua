return {
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {},
    init = function()
      vim.g.have_mini_icons = true
    end,
    config = function(_, opts)
      require("mini.icons").setup(opts)
      require("mini.icons").mock_nvim_web_devicons()
    end,
  },
}
