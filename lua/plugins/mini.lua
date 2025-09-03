return {
	"nvim-mini/mini.nvim",
	version = "*",
	config = function()
		require("mini.pairs").setup()
		require("mini.ai").setup()
		require("mini.files").setup()
		require("mini.git").setup()
		require("mini.diff").setup()
		require("mini.icons").setup()
		require("mini.statusline").setup()
		require("mini.notify").setup()
		require("mini.trailspace").setup({
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function()
					MiniTrailspace.trim()
				end,
			}),

			vim.api.nvim_create_autocmd("ModeChanged", {
				pattern = "*:n", -- Any mode to normal mode
				callback = function()
					if vim.bo.modifiable and not vim.bo.readonly then
						MiniTrailspace.trim()
					end
				end,
			}),
		})
		require("mini.surround").setup()
		require("mini.tabline").setup()
		require("mini.cursorword").setup()
		require("mini.completion").setup()
		require("mini.snippets").setup()
	end,
}
