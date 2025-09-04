return {
	"karb94/neoscroll.nvim",
	opts = {},
	lazy = false,
	config = function()
		require("neoscroll").setup({
			mappings = {},
			easing = "circular",
		})
	end,
}
