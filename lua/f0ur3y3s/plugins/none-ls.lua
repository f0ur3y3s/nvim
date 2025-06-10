return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.clang_format.with({
					filetypes = { "c", "cpp" },
					extra_args = {
						string.format("--style=file:%s/.clang-format", vim.fn.expand("$HOME")),
					},
				}),

				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier,
			},

			on_attach = function(client, bufnr)
				-- Fix: Use client:supports_method instead of client.supports_method
				if client:supports_method("textDocument/formatting") then
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({
								bufnr = bufnr,
								filter = function(c)
									return c.name == "null-ls"
								end,
							})
						end,
					})
				end
			end,
		})

		-- Keymap removed - now in which-key
	end,
}
