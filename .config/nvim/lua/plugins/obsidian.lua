return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    -- LOAD ON: Markdown files OR these specific commands/keys
    event = {
      "BufReadPre " .. vim.fn.expand "~" .. "/Documents/Notes/**.md",
      "BufNewFile " .. vim.fn.expand "~" .. "/Documents/Notes/**.md",
    },
    cmd = {
      "ObsidianQuickSwitch",
      "ObsidianSearch",
      "ObsidianNew",
      "ObsidianToday",
      "ObsidianOpen",
    },
    -- KEY SHORTCUTS (Global Access)
    keys = {
      { "<leader>on", "<cmd>ObsidianQuickSwitch<CR>", desc = "Obsidian: Quick Switcher" },
      { "<leader>os", "<cmd>ObsidianSearch<CR>", desc = "Obsidian: Search Text" },
      { "<leader>od", "<cmd>ObsidianToday<CR>", desc = "Obsidian: Daily Note" },
      { "<leader>nn", "<cmd>ObsidianNew<CR>", desc = "Obsidian: New Note" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim", -- Required for Picker
    },
    config = function()
      require("obsidian").setup({
        workspaces = {
          {
            name = "Notes",
            path = "/home/opx/Archive/IIBrain/Inbox/NOtes/",
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
        mappings = {
          ["<leader>ch"] = {
            action = function()
              return require("obsidian").util.toggle_checkbox()
            end,
            opts = { buffer = true, desc = "Toggle checkbox" },
          },
          -- Smart Enter: Follow link or create new line
          ["<cr>"] = {
            action = function()
              if require("obsidian").util.cursor_on_markdown_link() then
                return "<cmd>ObsidianFollowLink<CR>"
              else
                return "o"
              end
            end,
            opts = { buffer = true, expr = true },
          }
        },
      })
    end
  },

  -- Markdown Preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    -- Added shortcut for Preview
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", desc = "Markdown Preview", ft = "markdown" },
    },
  },

  {
    'MeanderingProgrammer/markdown.nvim',
    main = "render-markdown",
    opts = {},
    name = 'render-markdown',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  },

  {
    "preservim/vim-pencil",
    ft = { "markdown", "text" },
    -- Optional: Auto-enable pencil on markdown files
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.cmd("call pencil#init({'wrap': 'soft'})")
        end,
      })
    end
  },
}
