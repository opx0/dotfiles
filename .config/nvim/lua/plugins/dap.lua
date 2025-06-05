return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Setup DAP UI
      dapui.setup()

      -- Setup virtual text
      require('nvim-dap-virtual-text').setup()

      -- Custom breakpoint sign
      vim.fn.sign_define('DapBreakpoint', {
        text='🔴',
        texthl='DapBreakpoint',
        linehl='DapBreakpoint',
        numhl='DapBreakpoint'
      })

      -- Auto open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Keymaps
      vim.keymap.set("n", "<leader>dt", function() dapui.toggle() end, { desc = "Toggle DAP UI" })
      vim.keymap.set("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dc", function() dap.continue() end, { desc = "Continue debugging" })
      vim.keymap.set("n", "<leader>dr", function() dapui.open({reset = true}) end, { desc = "Reset DAP UI" })
      vim.keymap.set("n", "<leader>ds", function() dap.step_over() end, { desc = "Step over" })
      vim.keymap.set("n", "<leader>di", function() dap.step_into() end, { desc = "Step into" })
      vim.keymap.set("n", "<leader>do", function() dap.step_out() end, { desc = "Step out" })
    end
  }
}
