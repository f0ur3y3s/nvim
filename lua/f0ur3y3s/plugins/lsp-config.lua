local servers = {
	"clangd", -- Add it back
	"cmake",
	"lua_ls",
	"marksman",
	"pylsp",
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
				automatic_installation = true,
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
			vim.diagnostic.config({
				virtual_text = {
					enabled = true,
					source = false,
					prefix = "●",
					spacing = 4,
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "",
						[vim.diagnostic.severity.INFO] = "",
					},
				},
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "always",
				},
			})
		end,
	},
}
