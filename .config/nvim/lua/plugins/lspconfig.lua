return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			vim.api.nvim_create_autocmd({ "BufWritePre" }, { pattern = { "*.templ" }, callback = vim.lsp.buf.format })
		local on_attach = function(client, bufnr)
			-- LSP keymaps
			local opts = { buffer = bufnr, silent = true }

			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
			-- <leader>k (not <C-k>) so it doesn't shadow tmux-navigator "move up"
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
			-- Formatting handled by conform (<leader>cF + format-on-save); no <leader>f here
			-- (it shadowed the <leader>f Find prefix).

			-- Highlight references of the word under the cursor
			if client.server_capabilities.documentHighlightProvider then
				vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
				vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					group = "lsp_document_highlight",
					buffer = bufnr,
					callback = vim.lsp.buf.document_highlight,
				})
				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					group = "lsp_document_highlight",
					buffer = bufnr,
					callback = vim.lsp.buf.clear_references,
				})
			end
		end

			vim.lsp.config.lua_ls = {
				cmd = { "lua-language-server" },
				filetypes = { "lua" },
				root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
							disable = { "different-requires" },
						},
					},
				},
			}

			vim.lsp.config.tailwindcss = {
				cmd = { "tailwindcss-language-server", "--stdio" },
				filetypes = { "astro", "javascript", "typescript", "react" },
				root_markers = { "tailwind.config.js", "tailwind.config.cjs", "tailwind.config.mjs", "tailwind.config.ts", ".git" },
				on_attach = on_attach,
				capabilities = capabilities,
			}

			vim.lsp.config.nil_ls = {
				cmd = { "nil" },
				filetypes = { "nix" },
				root_markers = { "flake.nix", "default.nix", "shell.nix", ".git" },
				on_attach = on_attach,
				capabilities = capabilities,
			}

			vim.lsp.config.ts_ls = {
				cmd = { "typescript-language-server", "--stdio" },
				filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
				root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
				on_attach = on_attach,
				capabilities = capabilities,
			}

			vim.lsp.config.html = {
				cmd = { "vscode-html-language-server", "--stdio" },
				filetypes = { "html" },
				root_markers = { "package.json", ".git" },
				on_attach = on_attach,
				capabilities = capabilities,
			}

			vim.lsp.config.htmx = {
				cmd = { "htmx-lsp" },
				filetypes = { "html", "templ" },
				root_markers = { ".git" },
				on_attach = on_attach,
				capabilities = capabilities,
			}

			-- Enable the language servers
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("tailwindcss")
			vim.lsp.enable("nil_ls")
			vim.lsp.enable("ts_ls")
			vim.lsp.enable("html")
			vim.lsp.enable("htmx")
		end,
	},
}
