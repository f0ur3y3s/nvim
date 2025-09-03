return {
	"stevearc/conform.nvim",
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff" },
				c = { "clang-format" },
				cpp = { "clang-format" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			},
		})

		vim.api.nvim_create_autocmd("ModeChanged", {
			pattern = "*:n", -- Any mode to normal mode
			callback = function()
				if vim.bo.modifiable and not vim.bo.readonly then
					conform.format({
						lsp_fallback = true,
						async = false,
						timeout_ms = 500,
					})
				end
			end,
		})
	end,
}
