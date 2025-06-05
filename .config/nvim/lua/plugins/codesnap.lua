return {
  {
    "mistricky/codesnap.nvim",
    build = "make",
    cmd = { "CodeSnap", "CodeSnapSave" },
    config = function()
      require("codesnap").setup({
        save_path = "~/Pictures/CodeSnaps",
        has_breadcrumbs = true,
        bg_theme = "default",
        watermark = "",
      })

      -- Keymaps
      vim.keymap.set("v", "<leader>cs", "<cmd>CodeSnap<cr>", { desc = "Take code screenshot" })
      vim.keymap.set("v", "<leader>css", "<cmd>CodeSnapSave<cr>", { desc = "Save code screenshot" })
    end
  }
}
