return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		config = function()
			vim.lsp.config("*", {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim", "Snacks" },
							disable = { "different-requires" },
						},
					},
				},
			})

			-- nvim-lspconfig's htmx default attaches to ~20 filetypes (the list is
			-- copied from tailwindcss-intellisense), so it lands on every TS/JS
			-- buffer for nothing. Narrow it to where htmx attributes live.
			vim.lsp.config("htmx", {
				filetypes = { "html", "templ" },
			})

			vim.lsp.enable({
				"lua_ls",
				"gopls",
				"ts_ls",
				"html",
				"tailwindcss",
				"htmx",
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					local opts = { buffer = ev.buf, silent = true }

					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set("n", "<leader>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

					if client and client:supports_method("textDocument/documentHighlight") then
						local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
						vim.api.nvim_clear_autocmds({ buffer = ev.buf, group = group })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							group = group,
							buffer = ev.buf,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							group = group,
							buffer = ev.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})
		end,
	},
}
