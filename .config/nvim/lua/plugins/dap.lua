return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local mason_dap = require("mason-nvim-dap")

      mason_dap.setup({
        ensure_installed = {
          "codelldb",
          "python",
          "delve",
          "node2",
          "php",
        },
        automatic_installation = true,
        handlers = {
          function(config)
            mason_dap.default_setup(config)
          end,
        },
      })

      -- Setup DAP UI
      dapui.setup({
        icons = {
          expanded = "-",
          collapsed = "+",
          current_frame = "*",
        },
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            pause = "pause",
            play = "play",
            step_into = "into",
            step_over = "over",
            step_out = "out",
            step_back = "back",
            run_last = "last",
            terminate = "stop",
            disconnect = "disc",
          },
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.55 },
              { id = "breakpoints", size = 0.15 },
              { id = "stacks", size = 0.15 },
              { id = "watches", size = 0.15 },
            },
            size = 45,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 12,
            position = "bottom",
          },
        },
        floating = {
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
      })

      -- Setup virtual text
      require("nvim-dap-virtual-text").setup({
        commented = true,
      })

      -- Debug signs
      vim.fn.sign_define("DapBreakpoint", {
        text = "B",
        texthl = "DiagnosticSignError",
      })
      vim.fn.sign_define("DapBreakpointCondition", {
        text = "C",
        texthl = "DiagnosticSignWarn",
      })
      vim.fn.sign_define("DapBreakpointRejected", {
        text = "R",
        texthl = "DiagnosticSignHint",
      })
      vim.fn.sign_define("DapLogPoint", {
        text = "L",
        texthl = "DiagnosticSignInfo",
      })
      vim.fn.sign_define("DapStopped", {
        text = ">",
        texthl = "DiagnosticSignHint",
        linehl = "Visual",
      })

      -- Auto open/close DAP UI
      dap.listeners.before.attach["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.launch["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      local function executable_path()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end

      local function python_path()
        local cwd = vim.fn.getcwd()
        local candidates = {
          cwd .. "/venv/bin/python",
          cwd .. "/.venv/bin/python",
          cwd .. "/env/bin/python",
        }

        for _, candidate in ipairs(candidates) do
          if vim.fn.executable(candidate) == 1 then
            return candidate
          end
        end

        if vim.fn.executable("python3") == 1 then
          return "python3"
        end

        return "python"
      end

      local cpp_like = {
        {
          name = "Launch executable (codelldb)",
          type = "codelldb",
          request = "launch",
          program = executable_path,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
        {
          name = "Attach to process (codelldb)",
          type = "codelldb",
          request = "attach",
          pid = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }

      dap.configurations.c = cpp_like
      dap.configurations.cpp = cpp_like
      dap.configurations.rust = cpp_like

      local node_like = {
        {
          name = "Launch current file (node2)",
          type = "node2",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          protocol = "inspector",
          console = "integratedTerminal",
        },
        {
          name = "Attach to process (node --inspect)",
          type = "node2",
          request = "attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }

      dap.configurations.javascript = node_like
      dap.configurations.typescript = node_like
      dap.configurations.javascriptreact = node_like
      dap.configurations.typescriptreact = node_like

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch current file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          pythonPath = python_path,
        },
      }

      dap.configurations.go = {
        {
          type = "delve",
          name = "Debug current file",
          request = "launch",
          program = "${file}",
        },
        {
          type = "delve",
          name = "Debug test file",
          request = "launch",
          mode = "test",
          program = "${file}",
        },
        {
          type = "delve",
          name = "Debug package tests",
          request = "launch",
          mode = "test",
          program = "./${relativeFileDirname}",
        },
      }

      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug",
          port = 9003,
        },
      }

      -- Keymaps
      vim.keymap.set("n", "<leader>dt", function()
        dapui.toggle()
      end, { desc = "Toggle DAP UI", silent = true })
      vim.keymap.set("n", "<leader>db", function()
        dap.toggle_breakpoint()
      end, { desc = "Toggle Breakpoint", silent = true })
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Conditional Breakpoint", silent = true })
      vim.keymap.set("n", "<leader>dc", function()
        dap.continue()
      end, { desc = "Continue/Start", silent = true })
      vim.keymap.set("n", "<leader>dR", function()
        dap.run_last()
      end, { desc = "Run Last", silent = true })
      vim.keymap.set("n", "<leader>ds", function()
        dap.step_over()
      end, { desc = "Step Over", silent = true })
      vim.keymap.set("n", "<leader>di", function()
        dap.step_into()
      end, { desc = "Step Into", silent = true })
      vim.keymap.set("n", "<leader>do", function()
        dap.step_out()
      end, { desc = "Step Out", silent = true })
      vim.keymap.set("n", "<leader>dr", function()
        dap.repl.open()
      end, { desc = "Open REPL", silent = true })
      vim.keymap.set("n", "<leader>dl", function()
        dap.list_breakpoints()
      end, { desc = "List Breakpoints", silent = true })
      vim.keymap.set("n", "<leader>de", function()
        dap.set_exception_breakpoints({ "all" })
      end, { desc = "Exception Breakpoints", silent = true })
      vim.keymap.set("n", "<leader>dx", function()
        dap.clear_breakpoints()
      end, { desc = "Clear Breakpoints", silent = true })
      vim.keymap.set("n", "<leader>dq", function()
        dap.terminate()
        dapui.close()
      end, { desc = "Terminate Session", silent = true })
    end
  }
}
