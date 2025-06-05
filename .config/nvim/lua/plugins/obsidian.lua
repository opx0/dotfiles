return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",  -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("obsidian").setup({
        workspaces = {
          {
            name = "Notes",
            path = "/home/abhi/Documents/Notes/", -- Update this to your notes path
          },
        },
        -- Optional, customize how note IDs are generated given an optional title.
        note_id_func = function(title)
          -- Create note IDs in a Zettelkasten style with a timestamp and a suffix.
          local suffix = ""
          if title ~= nil then
            -- If title is given, transform it into valid file name.
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
          else
            -- If title is nil, just add 4 random uppercase letters to the suffix.
            for _ = 1, 4 do
              suffix = suffix .. string.char(math.random(65, 90))
            end
          end
          return tostring(os.time()) .. "-" .. suffix
        end,

        -- Optional, configure key mappings.
        mappings = {
          -- Toggle check-boxes.
          ["<leader>ch"] = {
            action = function()
              return require("obsidian").util.toggle_checkbox()
            end,
            opts = { buffer = true, desc = "Toggle checkbox" },
          },
        },
      })
    end
  },

  -- Markdown preview and rendering
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  {
    'MeanderingProgrammer/markdown.nvim',
    main = "render-markdown",
    opts = {},
    name = 'render-markdown',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  },

  -- Better writing experience
  {
    "preservim/vim-pencil",
    ft = { "markdown", "text" },
  },
}
