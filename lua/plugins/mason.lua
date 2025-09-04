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
		ensure_installed = {
			"clang-format",
			"clangd",
			"ruff",
			"stylua",
			"lua-ls",
			"pylsp", -- Add pylsp to ensure it's installed
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			local mason_lspconfig = require("mason-lspconfig")

			mason_lspconfig.setup({
				ensure_installed = {
					"lua_ls",
					"pylsp",
					"clangd",
				},
				automatic_installation = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-org/mason-lspconfig.nvim",
		},
		config = function()
			local lspconfig = require("lspconfig")

			-- Configure pylsp to disable noisy notifications
			lspconfig.pylsp.setup({
				settings = {
					pylsp = {
						plugins = {
							-- Disable noisy linters that spam notifications
							pycodestyle = { enabled = false },
							pyflakes = { enabled = false },
							mccabe = { enabled = false },
							-- Keep useful plugins
							pylint = {
								enabled = true,
								args = { "--rcfile=.pylintrc" }, -- Use your pylintrc
							},
							rope_completion = { enabled = true },
							rope_autoimport = { enabled = true },
							jedi_completion = { enabled = true },
							jedi_hover = { enabled = true },
							jedi_references = { enabled = true },
							jedi_signature_help = { enabled = true },
							jedi_symbols = { enabled = true },
						},
					},
				},
				-- Disable progress notifications for this server
				handlers = {
					["$/progress"] = function() end,
				},
			})

			-- Configure lua_ls
			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})

			-- Configure clangd
			lspconfig.clangd.setup({
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
				},
			})
		end,
	},
}
