-- return {
-- 	"nvimtools/none-ls.nvim",
-- 	event = "LazyFile",
-- 	dependencies = { "mason.nvim" },
-- 	init = function()
-- 		LazyVim.on_very_lazy(function()
-- 			-- register the formatter with LazyVim
-- 			LazyVim.format.register({
-- 				name = "none-ls.nvim",
-- 				priority = 200, -- set higher than conform, the builtin formatter
-- 				primary = true,
-- 				format = function(buf)
-- 					return LazyVim.lsp.format({
-- 						bufnr = buf,
-- 						filter = function(client)
-- 							return client.name == "null-ls"
-- 						end,
-- 					})
-- 				end,
-- 				sources = function(buf)
-- 					local ret = require("null-ls.sources").get_available(vim.bo[buf].filetype, "NULL_LS_FORMATTING")
-- 						or {}
-- 					return vim.tbl_map(function(source)
-- 						return source.name
-- 					end, ret)
-- 				end,
-- 			})
-- 		end)
-- 	end,
-- 	opts = function(_, opts)
-- 		local nls = require("null-ls")
-- 		opts.root_dir = opts.root_dir
-- 			or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
-- 		opts.sources = vim.list_extend(opts.sources or {}, {
-- 			nls.builtins.formatting.fish_indent,
-- 			nls.builtins.diagnostics.fish,
-- 			nls.builtins.formatting.stylua,
-- 			nls.builtins.formatting.shfmt,
-- 		})
-- 	end,
-- }

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
				null_ls.builtins.formatting.ruff,
				-- null_ls.builtins.formatting.
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
