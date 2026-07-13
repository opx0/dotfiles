return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      -- Responsive sizing -----------------------------------------------------
      -- A hardcoded width/height breaks down on narrow terminals (tmux panes,
      -- tiling-WM splits, SSH sessions) and short ones: a popup wider than the
      -- screen centers at a negative column and gets clipped on the left, and
      -- a completion menu taller than the space below the centered cmdline box
      -- runs off the bottom edge. Derive both from the live editor dimensions
      -- instead, and keep them in sync when the terminal is resized.

      -- Prefer 60 cols (matches the classic noice look), but never wider than
      -- the screen allows, with a small hard floor so it never goes negative.
      local function cmdline_width()
        local w = math.max(10, math.min(60, vim.o.columns - 4))
        return math.min(w, vim.o.columns)
      end

      -- Space below a vertically centered cmdline box is roughly half the
      -- screen height; leave margin for the box itself plus some breathing
      -- room, capped at 10 rows so it doesn't get absurdly tall on big
      -- monitors, floored at 3 so it's never useless on tiny terminals.
      local function popupmenu_max_height()
        return math.max(3, math.min(10, math.floor(vim.o.lines / 2) - 4))
      end

      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = true,
        },
        -- Centered cmdline, sized responsively (see helpers above).
        views = {
          cmdline_popup = {
            position = {
              row = "50%",
              col = "50%",
            },
            size = {
              width = cmdline_width(),
              height = "auto",
            },
          },
          -- Position is intentionally left unset: noice auto-anchors this
          -- directly below wherever cmdline_popup actually renders (see
          -- noice/ui/popupmenu/nui.lua). A hardcoded row fought the centered,
          -- auto-height cmdline box and caused visible overlap.
          cmdline_popupmenu = {
            size = {
              width = cmdline_width(),
              height = "auto",
              max_height = popupmenu_max_height(),
            },
          },
        },
        routes = {
          {
            filter = {
              event = 'msg_show',
              any = {
                { find = '%d+L, %d+B' },
                { find = '; after #%d+' },
                { find = '; before #%d+' },
                { find = '%d fewer lines' },
                { find = '%d more lines' },
              },
            },
            opts = { skip = true },
          }
        },
      })

      -- Keep sizes in sync with the terminal (tmux pane resize, WM reflow,
      -- window resize) by patching noice's live config in place -- it reads
      -- these values fresh every time the cmdline/menu is shown, so no
      -- re-setup() is needed.
      vim.api.nvim_create_autocmd("VimResized", {
        group = vim.api.nvim_create_augroup("NoiceResponsiveCmdline", { clear = true }),
        callback = function()
          local views = require("noice.config").options.views
          views.cmdline_popup.size.width = cmdline_width()
          views.cmdline_popupmenu.size.width = cmdline_width()
          views.cmdline_popupmenu.size.max_height = popupmenu_max_height()
        end,
      })

      -- Keymap to dismiss notifications
      vim.keymap.set("n", "<leader>nd", ":Noice dismiss<CR>", {
        noremap = true,
        desc = "Dismiss Noice notifications"
      })
    end
  }
}
