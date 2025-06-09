return {
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = function()
      return require("mini.icons").setup() -- Use default setup
    end,
    init = function()
      -- Set global variable for other plugins to use
      vim.g.have_mini_icons = true
      -- Or, more robustly, check if 'mini.icons' is setup
      -- This requires 'mini.icons' to be already loaded or mini.nvim to be setup
      -- if pcall(require, 'mini.icons') then
      --   vim.g.have_mini_icons = true
      -- end
    end,
  },
}
