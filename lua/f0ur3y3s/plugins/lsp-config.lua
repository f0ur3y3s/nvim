local servers = {
	"clangd",
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
			vim.diagnostic.reset()
			vim.g.loaded_syntax_completion = 1
			vim.g.loaded_syntaxcomplete = 1
			vim.diagnostic.config({
				virtual_text = {
					enabled = true,
					source = false,
					prefix = "●",
					spacing = 2,
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

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			local function setup_clangd()
				-- Kill any existing clangd processes
				local active_clients = vim.lsp.get_active_clients({ name = "clangd" })
				for _, client in pairs(active_clients) do
					client.stop()
				end
				vim.defer_fn(function()
					lspconfig.clangd.setup({
						capabilities = capabilities,
						cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed" },
						on_attach = function(client, bufnr)
							-- Disable any other diagnostic sources for C files
							vim.api.nvim_buf_set_option(bufnr, "makeprg", "")
						end,
					})
				end, 100)
			end

			-- set up other servers normally
			for _, server in ipairs(servers) do
				if server ~= "clangd" then
					lspconfig[server].setup({
						capabilities = capabilities,
					})
				end
			end
			setup_clangd()
			local kmp = vim.keymap
			kmp.set("n", "K", vim.lsp.buf.hover, {})
			kmp.set("n", "<leader>gd", vim.lsp.buf.definition, {})
			kmp.set("n", "<leader>gr", vim.lsp.buf.references, {})
			kmp.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
			kmp.set("n", "<leader>e", vim.diagnostic.open_float, {})
			kmp.set("n", "[d", vim.diagnostic.goto_prev, {})
			kmp.set("n", "]d", vim.diagnostic.goto_next, {})
		end,
	},
}
