local servers = {
	"clangd",
	"cmake",
	"lua_ls",
	"marksman",
	"ruff",
	"vimls",
}

return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		dependencies = {
			"williamboman/mason.nvim",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = servers,
				-- Removed deprecated automatic_enable option
				handlers = {
					-- Default handler for all servers
					function(server_name)
						local capabilities = require("cmp_nvim_lsp").default_capabilities()
						require("lspconfig")[server_name].setup({
							capabilities = capabilities,
						})
					end,
					-- Special clangd setup
					["clangd"] = function()
						local capabilities = require("cmp_nvim_lsp").default_capabilities()
						require("lspconfig").clangd.setup({
							capabilities = capabilities,
							cmd = {
								"clangd",
								"--background-index",
								"--clang-tidy",
								"--completion-style=detailed",
								"--enable-config",
							},
							-- Disable clangd formatting (let none-ls handle it)
							on_attach = function(client, bufnr)
								client.server_capabilities.documentFormattingProvider = false
								client.server_capabilities.documentRangeFormattingProvider = false
							end,
						})
					end,
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			-- Enhanced diagnostic configuration for 0.11
			vim.diagnostic.config({
				-- Enable virtual text (disabled by default in 0.11)
				-- virtual_text = {
				-- 	enabled = true,
				-- 	source = false,
				-- 	prefix = "●",
				-- 	spacing = 4,
				-- 	-- New 0.11 feature: only show at cursor line
				-- 	current_line = false,
				-- },
				-- Updated signs configuration
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "",
						[vim.diagnostic.severity.INFO] = "",
					},
					-- Signs are now sorted by severity automatically
				},
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "always",
				},
				-- New 0.11 feature: virtual lines for diagnostics
				-- Uncomment to enable:
				virtual_lines = {
					enabled = true,
				},
			})

			-- Enhanced hover and signature help (leverages 0.11 improvements)
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
			})

			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				border = "rounded",
			})
		end,
	},
}
