local vault = vim.fn.expand("~") .. "/Resources/MSB"

return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    event = {
      "BufReadPre " .. vault .. "/**.md",
      "BufNewFile " .. vault .. "/**.md",
    },
    cmd = {
      "Obsidian",
      "ObsidianQuickSwitch",
      "ObsidianSearch",
      "ObsidianNew",
      "ObsidianToday",
      "ObsidianOpen",
    },
    keys = {
      { "<leader>on", "<cmd>Obsidian quick_switch<CR>", desc = "Obsidian: Quick Switcher" },
      { "<leader>os", "<cmd>Obsidian search<CR>", desc = "Obsidian: Search Text" },
      { "<leader>od", "<cmd>Obsidian today<CR>", desc = "Obsidian: Daily Note" },
      { "<leader>nn", "<cmd>Obsidian new<CR>", desc = "Obsidian: New Note" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = "Notes",
          path = vault,
        },
      },
      note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,
      callbacks = {
        enter_note = function(note)
          vim.keymap.set("n", "<leader>ch", "<cmd>Obsidian toggle_checkbox<cr>", {
            buffer = note.bufnr,
            desc = "Toggle checkbox",
          })
        end,
      },
    },
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", desc = "Markdown Preview", ft = "markdown" },
    },
  },

  {
    'MeanderingProgrammer/markdown.nvim',
    main = "render-markdown",
    name = 'render-markdown',
    ft = { "markdown" },
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' },
  },

  {
    "preservim/vim-pencil",
    ft = { "markdown", "text" },
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.fn["pencil#init"]({ wrap = "soft" })
        end,
      })
    end
  },
}
