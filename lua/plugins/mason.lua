return {
	{
		"mason-org/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			-- automatic_enable defaults to true: installed servers are
			-- enabled via vim.lsp.enable(), reading config from lsp/*.lua
			ensure_installed = { "clangd", "lua_ls", "ruff" },
		},
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			-- non-LSP mason packages (formatters, linters, DAP adapters);
			-- LSP servers are handled by mason-lspconfig's ensure_installed above
			ensure_installed = { "mdformat", "stylua", "clang-format" },
		},
	},
}
