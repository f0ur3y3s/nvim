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
				markdown = { "mdformat" },
			},
			format_on_save = {
				lsp_fallback = true, -- use the attached LSP's formatter for filetypes not listed above
				async = false,
				timeout_ms = 500,
			},
		})
	end,
}
