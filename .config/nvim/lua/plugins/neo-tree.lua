return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    keys = {
      {
        "<leader>e",
        function()
          -- Smart toggle: from the editor, focus the tree and reveal the current
          -- file; from inside the tree, close it. (No accidental close-on-focus.)
          if vim.bo.filetype == "neo-tree" then
            vim.cmd("Neotree close")
          else
            vim.cmd("Neotree reveal")
          end
        end,
        desc = "File Explorer (focus / close)",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    -- Load neo-tree when nvim is started on a directory (e.g. `nvim .`),
    -- so it can take over from netrw.
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = vim.uv.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      -- Left false (the default): close_if_last_window=true makes neo-tree warn
      -- "cannot close, file modified" and feeds the WinClosed get_state() crash.
      close_if_last_window = false,
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        hijack_netrw_behavior = "open_default",
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      window = { width = 32 },
    },
  },
}
