-- Three plugins split the Mason workflow because their `ensure_installed`
-- lists are NOT interchangeable:
--   - mason.nvim itself has no ensure_installed option at all — it's just
--     the registry + :Mason UI (icons below).
--   - mason-lspconfig's ensure_installed only accepts lspconfig server
--     names; it validates against that list and warns on anything else
--     (e.g. a formatter), silently skipping it.
--   - mason-tool-installer's ensure_installed accepts arbitrary mason
--     registry packages, so it's the one that actually installs formatters.
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
