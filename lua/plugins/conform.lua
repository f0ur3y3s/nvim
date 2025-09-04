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
				python = { "ruff_format", "ruff_organize_imports" }, -- Updated for newer ruff
				-- Alternative if using older ruff:
				-- python = { "ruff" },
				c = { "clang-format" },
				cpp = { "clang-format" },
			},

			-- Custom formatter configuration (if needed)
			formatters = {
				ruff_format = {
					command = "ruff",
					args = { "format", "--stdin-filename", "$FILENAME", "-" },
					stdin = true,
					cwd = require("conform.util").root_file({
						"pyproject.toml",
						"ruff.toml",
						".ruff.toml",
					}),
				},
				ruff_organize_imports = {
					command = "ruff",
					args = { "check", "--select", "I", "--fix", "--stdin-filename", "$FILENAME", "-" },
					stdin = true,
					cwd = require("conform.util").root_file({
						"pyproject.toml",
						"ruff.toml",
						".ruff.toml",
					}),
				},
			},

			format_on_save = function(bufnr)
				-- Disable format on save for specific file types or conditions
				local filetype = vim.bo[bufnr].filetype

				-- Debug: Print when format on save is called
				print("Format on save triggered for filetype:", filetype)

				return {
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000, -- Increased timeout
					bufnr = bufnr,
				}
			end,

			-- Optional: Add notification when formatting
			notify_on_error = true,

			-- Log level for debugging
			log_level = vim.log.levels.DEBUG,
		})

		-- Debug command to check available formatters
		vim.api.nvim_create_user_command("ConformInfo", function()
			local formatters = conform.list_formatters(0)
			print("Available formatters for current buffer:")
			for _, formatter in ipairs(formatters) do
				print("- " .. formatter.name .. " (available: " .. tostring(formatter.available) .. ")")
			end
		end, {})
	end,
}
