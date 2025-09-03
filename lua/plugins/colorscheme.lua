-- return {
-- 	"nyoom-engineering/oxocarbon.nvim",
-- 	config = function()
-- 		vim.opt.background = "dark"
-- 		vim.cmd([[colorscheme oxocarbon]])
-- 	end,
-- }

return {
	"EdenEast/nightfox.nvim",
	config = function()
		require("nightfox").setup({
			options = {
				styles = {
					comments = "italic",
					keywords = "bold",
					types = "italic, bold",
				},
			},
		})
		vim.cmd([[colorscheme carbonfox]])
	end,
}
