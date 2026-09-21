return {
  "NickvanDyke/opencode.nvim",
  event = "VeryLazy",
  dependencies = {
    { "folke/snacks.nvim", opts = { input = { enabled = true } } },
  },
  config = function()
    vim.g.opencode_opts = {}

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { desc = desc })
    end

    map("n", "<leader>at", function() require("opencode").toggle() end, "Opencode: toggle")
    map("n", "<leader>aa", function() require("opencode").ask("@cursor: ") end, "Opencode: ask about this")
    map("v", "<leader>aa", function() require("opencode").ask("@selection: ") end, "Opencode: ask about selection")
    map("n", "<leader>a+", function() require("opencode").prompt("@buffer", { append = true }) end, "Opencode: add buffer")
    map("v", "<leader>a+", function() require("opencode").prompt("@selection", { append = true }) end, "Opencode: add selection")
    map("n", "<leader>ae", function() require("opencode").prompt("Explain @cursor and its context") end, "Opencode: explain this")
    map("n", "<leader>an", function() require("opencode").command("session_new") end, "Opencode: new session")
    map({ "n", "v" }, "<leader>as", function() require("opencode").select() end, "Opencode: select prompt")
    map("n", "<S-C-u>", function() require("opencode").command("messages_half_page_up") end, "Opencode: page up")
    map("n", "<S-C-d>", function() require("opencode").command("messages_half_page_down") end, "Opencode: page down")
  end,
}
